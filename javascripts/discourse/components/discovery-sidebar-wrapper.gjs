import Component from "@glimmer/component";
import DiscoverySidebar from "./discovery-sidebar";
import DiscoverySidebarBottom from "./discovery-sidebar-bottom";

export default class DiscoverySidebarWrapper extends Component {
  <template>
    <div class="discovery-sidebar-column">
      <DiscoverySidebar />
      <DiscoverySidebarBottom />
    </div>
  </template>
}
