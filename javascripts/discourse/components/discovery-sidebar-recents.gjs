import Component from "@glimmer/component";
import { service } from "@ember/service";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import positionFixedToColumn from "../modifiers/position-fixed-to-column";

export default class DiscoverySidebarRecents extends Component {
  @service router;
  @tracked recentTopics = [];

  constructor() {
    super(...arguments);
    this.loadRecentTopics();
  }

  @action
  async loadRecentTopics() {
    try {
      // Fetch the topic list which includes recently_viewed from the user-data-api plugin
      const response = await fetch("/latest.json");
      const data = await response.json();

      if (data.topic_list?.recently_viewed) {
        this.recentTopics = data.topic_list.recently_viewed;
      }
    } catch (error) {
      console.error("Failed to load recent topics:", error);
    }
  }

  <template>
    <aside class="discovery-sidebar-recents" {{positionFixedToColumn}}>
      <div class="discovery-sidebar__content">
        <h3 class="discovery-sidebar-recents__title">Recently Viewed</h3>
        {{#if this.recentTopics.length}}
          <ul class="discovery-sidebar-recents__list">
            {{#each this.recentTopics as |topic|}}
              <li class="discovery-sidebar-recents__item">
                <a href="/t/{{topic.slug}}/{{topic.id}}" class="discovery-sidebar-recents__link">
                  {{topic.fancy_title}}
                </a>
              </li>
            {{/each}}
          </ul>
        {{else}}
          <p class="discovery-sidebar-recents__empty">No recently viewed topics</p>
        {{/if}}
      </div>
    </aside>
  </template>
}
