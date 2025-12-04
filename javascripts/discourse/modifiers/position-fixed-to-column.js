import { registerDestructor } from "@ember/destroyable";
import Modifier from "ember-modifier";

export default class PositionFixedToColumn extends Modifier {
  constructor(owner, args) {
    super(owner, args);
    registerDestructor(this, (instance) => instance.cleanup());
  }

  modify(element) {
    this.element = element;
    this.updatePosition();

    window.addEventListener("resize", this.updatePosition);
    window.addEventListener("scroll", this.updatePosition);
  }

  updatePosition = () => {
    const column = this.element?.closest(".discovery-sidebar-column");
    if (column) {
      const rect = column.getBoundingClientRect();
      this.element.style.left = `${rect.left}px`;

      // If this is the top sidebar, align with navigation controls
      if (this.element.classList.contains("discovery-sidebar")) {
        const navContainer = document.querySelector(".navigation-container");
        if (navContainer) {
          const navRect = navContainer.getBoundingClientRect();
          this.element.style.top = `${navRect.bottom + 16}px`;
        }
      }
    }
  };

  cleanup() {
    window.removeEventListener("resize", this.updatePosition);
    window.removeEventListener("scroll", this.updatePosition);
  }
}
