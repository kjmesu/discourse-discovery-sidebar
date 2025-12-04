import { withPluginApi } from "discourse/lib/plugin-api";
import { or } from "discourse/truth-helpers";
import DiscoverySidebarWrapper from "../components/discovery-sidebar-wrapper";

export default {
  name: "discovery-sidebar-init",

  initialize() {
    withPluginApi("1.14.0", (api) => {
      const ttService = api.container.lookup("service:topic-thumbnails");

      if (!ttService) {
        console.warn("discourse-discovery-sidebar requires discourse-topic-thumbnails component");
        return;
      }

      api.renderInOutlet(
        "before-list-area",
        <template>
          {{#if (or ttService.displayCardStyle ttService.displayCompactStyle)}}
            <DiscoverySidebarWrapper />
          {{/if}}
        </template>
      );
    });
  },
};
