import Component from "@glimmer/component";
import { service } from "@ember/service";
import DiscoverySidebar from "./discovery-sidebar";
import DiscoverySidebarFooter from "./discovery-sidebar-footer";

export default class DiscoverySidebarWrapper extends Component {
  @service siteSettings;

  get sidebarEnabled() {
    return this.siteSettings.discovery_sidebar_enabled;
  }

  get footerEnabled() {
    return this.siteSettings.discovery_sidebar_footer_enabled;
  }

  get sidebarContent() {
    return this.siteSettings.discovery_sidebar_content;
  }

  <template>
    <div class="discovery-sidebar-column">
      {{#if this.sidebarEnabled}}
        <DiscoverySidebar @content={{this.sidebarContent}} />
      {{/if}}
      {{#if this.footerEnabled}}
        <DiscoverySidebarFooter />
      {{/if}}
    </div>
  </template>
}
