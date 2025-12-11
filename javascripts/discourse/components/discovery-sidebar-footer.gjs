import Component from "@glimmer/component";

export default class DiscoverySidebarFooter extends Component {
  <template>
    <aside class="discovery-sidebar-footer">
      <nav class="discovery-sidebar__content">
        <a href="/tos">Terms of Service</a>
        <span class="discovery-sidebar__separator">|</span>
        <a href="/privacy">Privacy Policy</a>
      </nav>
      <p class="discovery-sidebar__copyright">GAFSHUB © 2025. All rights reserved.</p>
    </aside>
  </template>
}
