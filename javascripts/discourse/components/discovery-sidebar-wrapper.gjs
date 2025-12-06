import Component from "@glimmer/component";
import DiscoverySidebar from "./discovery-sidebar";
import DiscoverySidebarFooter from "./discovery-sidebar-footer";
import DiscoverySidebarRecents from "./discovery-sidebar-recents";

export default class DiscoverySidebarWrapper extends Component {
  <template>
    <div class="discovery-sidebar-column">
      {{#if settings.discovery_sidebar_enabled}}
        <DiscoverySidebar @content={{settings.discovery_sidebar_content}} />
      {{/if}}
      {{#if settings.discovery_sidebar_recents_enabled}}
        <DiscoverySidebarRecents />
      {{/if}}
      {{#if settings.discovery_sidebar_footer_enabled}}
        <DiscoverySidebarFooter />
      {{/if}}
    </div>
  </template>
}
