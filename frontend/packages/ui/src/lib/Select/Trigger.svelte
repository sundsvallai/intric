<script lang="ts">
  import { IconChevronDown } from "@intric/icons/chevron-down";
  import { getSelect } from "./ctx.js";

  export let placeholder = "select";
  export let error = false;

  const {
    elements: { trigger },
    states: { selectedLabel }
  } = getSelect();
</script>

<button
  class="flex h-10 items-center justify-between
overflow-hidden rounded-lg border {error
    ? 'border-2 border-negative-default'
    : 'border-stronger'} bg-primary px-3 py-2 shadow ring-default focus-within:ring-2 hover:ring-2 focus-visible:ring-2"
  {...$trigger}
  use:trigger
>
  <div class="truncate">
    {$selectedLabel || placeholder}
  </div>
  <IconChevronDown />
</button>
