import Component from "@glimmer/component";
import positionFixedToColumn from "../modifiers/position-fixed-to-column";

export default class DiscoverySidebarFooter extends Component {
  <template>
    <aside class="discovery-sidebar-footer" {{positionFixedToColumn}}>
      <nav class="discovery-sidebar__content">
        <a href="/tos">Terms of Service</a>
        <span class="discovery-sidebar__separator">|</span>
        <a href="/privacy">Privacy Policy</a>
      </nav>
      <p class="discovery-sidebar__copyright">GAFSCOM © 2025. All rights reserved.</p>
    </aside>
  </template>
}
