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
      console.log("Bottom sidebar positioned at:", rect.left);
    } else {
      console.warn("Could not find .discovery-sidebar-column parent");
    }
  };

  cleanup() {
    window.removeEventListener("resize", this.updatePosition);
    window.removeEventListener("scroll", this.updatePosition);
  }
}
