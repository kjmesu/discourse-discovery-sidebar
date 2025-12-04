import Component from "@glimmer/component";
import positionFixedToColumn from "../modifiers/position-fixed-to-column";

export default class DiscoverySidebarBottom extends Component {
  <template>
    <aside class="discovery-sidebar-bottom" {{positionFixedToColumn}}>
      <div class="discovery-sidebar__content">
        <p>GAFSCOM © 2025. All rights reserved.</p>
      </div>
    </aside>
  </template>
}
