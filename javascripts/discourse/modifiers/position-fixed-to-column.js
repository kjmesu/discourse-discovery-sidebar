import { registerDestructor } from "@ember/destroyable";
import Modifier from "ember-modifier";

export default class PositionFixedToColumn extends Modifier {
  constructor(owner, args) {
    super(owner, args);
    registerDestructor(this, (instance) => instance.cleanup());
  }

  modify(element) {
    this.element = element;

    // Initial position with multiple attempts to ensure DOM is fully settled
    requestAnimationFrame(() => {
      this.updatePosition();

      // Run again after a delay to catch any late-rendering elements
      setTimeout(() => {
        this.updatePosition();
      }, 250);
    });

    window.addEventListener("resize", this.updatePosition);
    window.addEventListener("scroll", this.updatePosition);
  }

  updatePosition = () => {
    const column = this.element?.closest(".discovery-sidebar-column");
    if (!column) return;

    const rect = column.getBoundingClientRect();
    this.element.style.left = `${rect.left}px`;

    // If this is the top sidebar, set top position relative to navigation
    if (this.element.classList.contains("discovery-sidebar")) {
      const navContainer = document.querySelector(".navigation-container");
      const headerOffset = parseInt(getComputedStyle(document.documentElement).getPropertyValue('--header-offset') || '60');

      if (navContainer) {
        const navRect = navContainer.getBoundingClientRect();
        // If nav is below the header, position below nav. Otherwise, below header
        const topPosition = navRect.bottom > headerOffset
          ? `${navRect.bottom + 16}px`
          : `${headerOffset + 16}px`;

        this.element.style.top = topPosition;
      } else {
        this.element.style.top = `${headerOffset + 16}px`;
      }

      // Make visible after positioning
      this.element.classList.add("is-positioned");
    }
  };

  cleanup() {
    window.removeEventListener("resize", this.updatePosition);
    window.removeEventListener("scroll", this.updatePosition);
  }
}
