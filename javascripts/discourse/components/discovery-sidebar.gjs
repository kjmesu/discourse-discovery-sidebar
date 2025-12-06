import Component from "@glimmer/component";
import { htmlSafe } from "@ember/template";
import { cookAsync } from "discourse/lib/text";
import { tracked } from "@glimmer/tracking";

export default class DiscoverySidebar extends Component {
  @tracked cookedContent = "";

  constructor() {
    super(...arguments);
    this.cookMarkdown();
  }

  async cookMarkdown() {
    const markdown = this.args.content || "";
    const cooked = await cookAsync(markdown);
    this.cookedContent = htmlSafe(cooked);
  }

  <template>
    <aside class="discovery-sidebar">
      <div class="discovery-sidebar__content">
        {{this.cookedContent}}
      </div>
    </aside>
  </template>
}
