// @ts-check
import { readFile, writeFile, readdir } from "fs/promises";
import { resolve, join, dirname } from "path";
import { fileURLToPath } from "url";
import prettier from "prettier";

const paths = createConfig({
  svgFolderName: "svg",
  typeFileName: "types.d.ts",
  templateFileName: "Icon.svelte"
});

/**
 * @param {Object} params
 * @param {string} params.svgFolderName Name of subfolder with all the svg icons
 * @param {string} params.typeFileName Name of the emitted type file
 * @param {string} params.templateFileName Name of the template svelte component
 */
function createConfig(params) {
  const baseFolder = dirname(fileURLToPath(import.meta.url));

  return {
    iconFolderPath: resolve(baseFolder, params.svgFolderName),
    typeFilePath: resolve(baseFolder, params.typeFileName),
    templateFilePath: resolve(baseFolder, params.templateFileName)
  };
}

/**
 * Creates a Vite plugin for automatic Svelte icon components
 * @returns {import('vite').Plugin}
 */
export const intricIcons = () => {
  const moduleId = "@intric/icons/";
  // Resolved import needs to start with "/" otherwise it will not be compiled as svelte code
  const resolvedPrefix = "/";

  return {
    name: "vite-plugin-intric-icons",
    enforce: "pre",

    buildStart() {
      this.addWatchFile(paths.iconFolderPath);
      this.addWatchFile(paths.templateFilePath);
      generateTypes();
    },

    resolveId(id) {
      return id.startsWith(moduleId) ? resolvedPrefix + id : null;
    },

    async load(id) {
      if (!id.startsWith(resolvedPrefix + moduleId)) return null;

      // First load will go to @intric/icons/app -> we export {default as IconApp} from @intric/icons/app.svelte
      // This step is not strictly required, but allows us to only allow namend imports/export of icons
      if (!id.endsWith(".svelte")) {
        return createNamedExport(id);
      }

      // Second load will go to @intric/icons/app.svelte -> now we actual export the Icon component
      const code = await createIconComponent(id);

      return {
        code,
        // Return empty src map so vite is not complaining about missing maps
        map: { version: 3, mappings: "", sources: [] }
      };
    },

    watchChange(id, change) {
      if (hasIconSourceChanged(id, change)) generateTypes();
    }
  };
};

/** @param {string} id */
function createNamedExport(id) {
  return `import Icon from "${id.slice(1)}.svelte"; export { Icon as ${getIconName(id)} };`;
}

/**
 * @param {string} id
 * @return {Promise<string>}
 * */
async function createIconComponent(id) {
  const iconName = id.split("/").pop()?.replace(".svelte", "");
  const svgPath = join(paths.iconFolderPath, `${iconName}.svg`);
  try {
    const svg = await readFile(svgPath, "utf-8");
    const content = svg
      .replace(/<svg[^>]*>|<\/svg[^>]*>/g, "")
      .replace(/\{/g, "&#123;")
      .replace(/\}/g, "&#125;")
      .replace(/`/g, "&#96;")
      .replace(/\\([trn])/g, " ");

    const imports = `<script>import "${svgPath}"; import Icon from "${paths.templateFilePath}";</script>`;
    const component = `<Icon src={\`${content}\`} {...$$restProps} />`;

    return imports + component;
  } catch (e) {
    console.error(`Failed to auto-create component for icon ${iconName}.svg`);
  }
  return "";
}

/**
 * @param {string} id
 * @param {{event: "create" | "update" | "delete"}} change
 */
function hasIconSourceChanged(id, change) {
  const svgChanged = () =>
    id.startsWith(paths.iconFolderPath) &&
    id.endsWith(".svg") &&
    (change.event === "create" || change.event === "delete");

  const templateChanged = () => id === paths.templateFilePath && change.event === "update";

  return svgChanged() || templateChanged();
}

async function generateTypes() {
  const [iconFiles, templateFileContents] = await Promise.all([
    readdir(paths.iconFolderPath, { withFileTypes: false }),
    readFile(paths.templateFilePath, "utf-8")
  ]);

  const code =
    createCommonTypeDeclaration(templateFileContents) +
    createIndividualModuleDeclarations(iconFiles);

  // Format the output with prettier, otherwise lints will fail all the time
  const types = await prettier.format(code, {
    printWidth: 100,
    parser: "typescript"
  });

  await writeFile(paths.typeFilePath, types, "utf-8");
}

/** @param {string} iconTemplateContents */
function createCommonTypeDeclaration(iconTemplateContents) {
  // We want to extract the Props type defined in the icon template to re-use it for declaring all exported icons
  // The regex specifically looks for the type "IconProps"
  /** @type {RegExpMatchArray | null} */
  const iconPropsMatch = iconTemplateContents.match(/type IconProps = {([^}]*)}/);
  if (!iconPropsMatch) {
    throw new Error(
      `Can't autogenerate icon types. IconProps type not found in ${paths.templateFilePath} file`
    );
  }
  const iconPropsType = iconPropsMatch[1].trim();

  // We declare the common interface of all icons
  return `
  /* Types auto-generated by vite-plugin-intric-icons, do not edit. */
  declare module "@intric/icons/*" {
  import { SvelteComponent } from "svelte";
  import type { SvelteHTMLElements } from "svelte/elements";
  type IconProps = {${iconPropsType}};
  export class Icon extends SvelteComponent<IconProps & SvelteHTMLElements["svg"]> {}}
  declare module "@intric/icons" {
  import { Icon as IconComponent } from "@intric/icons/*";
  export type Icon = typeof IconComponent;
  }`;
}

/** @param {string[]} iconFilePaths */
function createIndividualModuleDeclarations(iconFilePaths) {
  const getModuleName = (/** @type {string} */ icon) => "@intric/icons/" + icon.replace(".svg", "");
  return iconFilePaths.reduce((acc, icon) => {
    acc += `declare module "${getModuleName(icon)}" {
      export {Icon as ${getIconName(icon)}} from "@intric/icons/*";
    }`;
    return acc;
  }, "");
}

/**
 * @param {string} icon
 * */
function getIconName(icon) {
  // Isolte icon id from path
  const iconId = icon.split("/").pop()?.replace(".svg", "");
  // Transform into Pascal case
  const iconUpper = iconId?.split("-").reduce((acc, part) => (acc += firstToUpper(part)), "");
  // Prepend icon prefix
  return "Icon" + iconUpper;
}

/**
 * @param {string} string
 */
function firstToUpper(string) {
  return string[0].toUpperCase() + string.slice(1);
}
