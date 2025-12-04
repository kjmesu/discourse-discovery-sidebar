import Component from "@glimmer/component";
import positionFixedToColumn from "../modifiers/position-fixed-to-column";

export default class DiscoverySidebar extends Component {
  <template>
    <aside class="discovery-sidebar" {{positionFixedToColumn}}>
      <div class="discovery-sidebar__content">
        <h3>I'm a sidebar!</h3>
        <p>This is here to let you know that MSJ is gay.</p>
        <p>That is all.</p>
        <p>Carry on.</p>
      </div>
    </aside>
  </template>
}
