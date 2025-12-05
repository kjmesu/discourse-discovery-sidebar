import Component from "@glimmer/component";
import { service } from "@ember/service";
import { or } from "discourse/truth-helpers";
import DiscoverySidebar from "./discovery-sidebar";
import DiscoverySidebarFooter from "./discovery-sidebar-footer";

export default class DiscoverySidebarWrapper extends Component {
  @service siteSettings;

  get showSidebar() {
    const enabled = this.siteSettings.discovery_sidebar_enabled;
    console.log("Sidebar enabled:", enabled);
    return enabled;
  }

  get showFooter() {
    const enabled = this.siteSettings.discovery_sidebar_footer_enabled;
    console.log("Footer enabled:", enabled);
    return enabled;
  }

  get sidebarContent() {
    const content = this.siteSettings.discovery_sidebar_content;
    console.log("Sidebar content:", content);
    return content;
  }

  <template>
    {{#if (or this.showSidebar this.showFooter)}}
      <div class="discovery-sidebar-column">
        {{#if this.showSidebar}}
          <DiscoverySidebar @content={{this.sidebarContent}} />
        {{/if}}
        {{#if this.showFooter}}
          <DiscoverySidebarFooter />
        {{/if}}
      </div>
    {{/if}}
  </template>
}
