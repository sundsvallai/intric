<script lang="ts">
  import TemplateIcon from "../TemplateIcon.svelte";
  import { formatEmojiTitle } from "$lib/core/formatting/formatEmojiTitle";
  import { Button, Dialog } from "@intric/ui";
  import { dynamicColour } from "$lib/core/colours";
  import { getTemplateController } from "../../TemplateController";
  import TemplateLanguageSwitcher from "./TemplateLanguageSwitcher.svelte";

  let {
    getCategorisedTemplates,
    selectTemplate,
    resourceName,
    state: { showTemplateGallery, selectedTemplate }
  } = getTemplateController();
  const sections = getCategorisedTemplates();

  let currentlySelected = $selectedTemplate;
</script>

<Dialog.Root openController={showTemplateGallery}>
  <Dialog.Content width="large">
    <Dialog.Section class="mt-2">
      <div class="flex items-center justify-between px-10 pb-10 pt-12">
        <div class="flex w-full flex-col border-default">
          <h3 class="px-4 pb-1 text-2xl font-bold">Select a template</h3>
          <p class="max-w-[50ch] px-4 text-secondary">
            Get started with one of the templates below. You can edit the {resourceName.singular} any
            time after creation.
          </p>
        </div>
        <TemplateLanguageSwitcher></TemplateLanguageSwitcher>
      </div>
      {#each sections as section}
        <div class="flex w-full flex-col gap-2 p-6 pb-2 last-of-type:pb-6">
          <div class="flex flex-col items-start gap-0.5 px-8 py-3">
            <h3 class="top-0 inline-block text-lg font-medium">
              {section.title}
            </h3>
            <p class="text-secondary">{section.description}</p>
          </div>
          <div class="grid w-full flex-grow grid-cols-1 gap-x-6 gap-y-4 px-2 lg:grid-cols-3">
            {#each section.templates as template}
              {@const isSelected = template.id === currentlySelected?.id}
              <button
                on:click|preventDefault={() => {
                  currentlySelected = template;
                }}
                {...dynamicColour({ basedOn: template.category })}
                class="rounded-2xl"
                data-selected={isSelected}
              >
                <div
                  class="tile-bg flex h-full flex-col gap-2.5 overflow-clip rounded-2xl border border-default p-4 px-5 transition-all"
                >
                  <div class="-ml-0.5 flex w-full items-center gap-3">
                    <TemplateIcon {template}></TemplateIcon>
                    <h4 class="text-left text-lg font-medium text-dynamic-stronger">
                      {formatEmojiTitle(template.name)}
                    </h4>
                  </div>
                  <p class="w-full flex-grow text-left">
                    {template.description}
                  </p>
                </div>
              </button>
            {/each}
          </div>
        </div>
      {/each}
    </Dialog.Section>

    <Dialog.Controls let:close>
      <Button
        on:click={() => {
          $showTemplateGallery = false;
        }}>Cancel</Button
      >
      <Button
        is={close}
        variant="primary"
        class="w-40"
        disabled={currentlySelected === null}
        on:click={() => {
          if (currentlySelected) {
            selectTemplate(currentlySelected);
          }
        }}>Choose template</Button
      >
    </Dialog.Controls>
  </Dialog.Content>
</Dialog.Root>

<style lang="postcss">
  button[data-selected="true"] {
    @apply focus:outline-offset-4;
  }

  button[data-selected="true"] > div {
    @apply border-accent-default shadow-md shadow-accent-dimmer outline outline-accent-default;
  }

  .tile-bg {
    background: linear-gradient(183deg, var(--dynamic-dimmer) 0%, var(--background-primary) 50%);
  }

  button[data-selected="true"] .tile-bg {
    background: linear-gradient(183deg, var(--dynamic-dimmer) 0%, var(--accent-dimmer) 50%);
  }

  .tile-bg:hover {
    background: var(--dynamic-dimmer);
    @apply ring-2 ring-default;
  }
</style>
