import Component from "@glimmer/component";
import { service } from "@ember/service";
import DiscoverySidebar from "./discovery-sidebar";
import DiscoverySidebarFooter from "./discovery-sidebar-footer";

export default class DiscoverySidebarWrapper extends Component {
  @service siteSettings;

  <template>
    <div class="discovery-sidebar-column">
      {{#if this.siteSettings.discovery_sidebar_enabled}}
        <DiscoverySidebar @content={{this.siteSettings.discovery_sidebar_content}} />
      {{/if}}
      {{#if this.siteSettings.discovery_sidebar_footer_enabled}}
        <DiscoverySidebarFooter />
      {{/if}}
    </div>
  </template>
}
