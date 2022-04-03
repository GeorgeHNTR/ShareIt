<template>
  <div>
    <warning-button
      @mouseover="toggleWarning"
      @mouseleave="toggleWarning"
      ref="warning-btn"
      class="warning warning-btn"
    />
    <warning-message :message="message" ref="warningMsg" />
  </div>
</template>

<script>
import WarningButton from "./WarningButton.vue"
import WarningMessage from "./WarningMessage.vue"

export default {
  components: { WarningButton, WarningMessage },
  props: {
    message: {
      type: String,
      required: true,
    },
  },
  methods: {
    toggleWarning() {
      const el = this.$refs["warningMsg"].$el
      if (el.style.display == "none" || el.style.display == "") {
        el.style.display = "block"
      } else {
        el.style.display = "none"
      }
    },
  },
}
</script>