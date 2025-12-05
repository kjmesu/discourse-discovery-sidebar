import Component from "@glimmer/component";
import DiscoverySidebar from "./discovery-sidebar";
import DiscoverySidebarFooter from "./discovery-sidebar-footer";

export default class DiscoverySidebarWrapper extends Component {
  <template>
    <div class="discovery-sidebar-column">
      <DiscoverySidebar @content="### I'm a sidebar!

This is here to let you know that MSJ is gay.

That is all.

Carry on." />
      <DiscoverySidebarFooter />
    </div>
  </template>
}
