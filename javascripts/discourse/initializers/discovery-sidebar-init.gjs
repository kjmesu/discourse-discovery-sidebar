import { withPluginApi } from "discourse/lib/plugin-api";
import { or } from "discourse/truth-helpers";
import DiscoverySidebar from "../components/discovery-sidebar";

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
        "before-topic-list-body",
        <template>
          {{#if (or ttService.displayCardStyle ttService.displayCompactStyle)}}
            <DiscoverySidebar />
          {{/if}}
        </template>
      );
    });
  },
};
