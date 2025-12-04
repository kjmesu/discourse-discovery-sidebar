import Component from "@glimmer/component";
import positionFixedToColumn from "../modifiers/position-fixed-to-column";

export default class DiscoverySidebarBottom extends Component {
  <template>
    <aside class="discovery-sidebar-bottom" {{positionFixedToColumn}}>
      <div class="discovery-sidebar__content">
        <h3>Bottom Sidebar</h3>
        <p>This sidebar sticks to the bottom of the viewport.</p>
      </div>
    </aside>
  </template>
}
