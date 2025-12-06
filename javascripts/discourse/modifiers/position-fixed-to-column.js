import { registerDestructor } from "@ember/destroyable";
import Modifier from "ember-modifier";

export default class PositionFixedToColumn extends Modifier {
  constructor(owner, args) {
    super(owner, args);
    registerDestructor(this, (instance) => instance.cleanup());
  }

  modify(element) {
    this.element = element;

    // Wait for DOM to be fully settled before positioning
    setTimeout(() => {
      this.updatePosition();
    }, 300);

    window.addEventListener("resize", this.updatePosition);
    window.addEventListener("scroll", this.updatePosition);
  }

  updatePosition = () => {
    const column = this.element?.closest(".discovery-sidebar-column");
    if (!column) return;

    const rect = column.getBoundingClientRect();
    const mainOutletWrapper = document.querySelector("#main-outlet-wrapper");

    if (!mainOutletWrapper) return;

    const wrapperRect = mainOutletWrapper.getBoundingClientRect();

    // Constrain left position within main-outlet-wrapper
    const leftPosition = Math.max(rect.left, wrapperRect.left);
    this.element.style.left = `${leftPosition}px`;

    // Calculate maximum width to stay within main-outlet-wrapper
    const maxWidth = Math.min(300, wrapperRect.right - leftPosition - 16);
    this.element.style.width = `${maxWidth}px`;
    this.element.style.maxWidth = `${maxWidth}px`;

    // Handle sidebars (excluding footer)
    if (this.element.classList.contains("discovery-sidebar")) {
      const navContainer = document.querySelector(".navigation-container");
      const headerOffset = parseInt(getComputedStyle(document.documentElement).getPropertyValue('--header-offset') || '60');

      let topPosition;

      if (navContainer) {
        const navRect = navContainer.getBoundingClientRect();
        // If nav is below the header, position below nav. Otherwise, below header
        topPosition = navRect.bottom > headerOffset
          ? navRect.bottom + 16
          : headerOffset + 16;
      } else {
        topPosition = headerOffset + 16;
      }

      // If this is the recents sidebar, position it below the main sidebar
      if (this.element.classList.contains("discovery-sidebar-recents")) {
        const mainSidebar = column.querySelector(".discovery-sidebar:not(.discovery-sidebar-recents)");
        if (mainSidebar) {
          const mainRect = mainSidebar.getBoundingClientRect();
          topPosition = mainRect.bottom + 16;
        }
      }

      // Constrain top position within main-outlet-wrapper
      topPosition = Math.max(topPosition, wrapperRect.top);

      this.element.style.top = `${topPosition}px`;

      // Make visible after positioning
      this.element.classList.add("is-positioned");
    }
  };

  cleanup() {
    window.removeEventListener("resize", this.updatePosition);
    window.removeEventListener("scroll", this.updatePosition);
  }
}
