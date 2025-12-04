import Component from "@glimmer/component";
import { htmlSafe } from "@ember/template";
import { cook } from "discourse/lib/text";
import positionFixedToColumn from "../modifiers/position-fixed-to-column";

export default class DiscoverySidebar extends Component {
  get cookedContent() {
    const markdown = this.args.content || "";
    return htmlSafe(cook(markdown));
  }

  <template>
    <aside class="discovery-sidebar" {{positionFixedToColumn}}>
      <div class="discovery-sidebar__content">
        {{this.cookedContent}}
      </div>
    </aside>
  </template>
}
