import Component from "@glimmer/component";
import { service } from "@ember/service";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import avatar from "discourse/helpers/avatar";
import ageWithTooltip from "discourse/helpers/age-with-tooltip";
import positionFixedToColumn from "../modifiers/position-fixed-to-column";

export default class DiscoverySidebarRecents extends Component {
  @service router;
  @service store;
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
        // Load user data for each topic
        const topicsWithUsers = await Promise.all(
          data.topic_list.recently_viewed.map(async (topic) => {
            let user = null;
            if (topic.posters?.[0]?.user_id) {
              const users = data.users || [];
              const userData = users.find(u => u.id === topic.posters[0].user_id);
              if (userData) {
                user = this.store.createRecord("user", userData);
              }
            }
            // Debug log to see thumbnail structure
            if (topic.thumbnails) {
              console.log("Topic thumbnails:", topic.id, topic.thumbnails);
            }
            return { ...topic, user };
          })
        );
        this.recentTopics = topicsWithUsers;
      }
    } catch (error) {
      console.error("Failed to load recent topics:", error);
    }
  }

  getThumbnailUrl(topic) {
    // Try different thumbnail sources
    if (topic.thumbnails && topic.thumbnails.length > 0) {
      // Look for common thumbnail sizes
      const thumbnail = topic.thumbnails.find(t => t.max_width === 200 || t.max_width === 250)
                     || topic.thumbnails[0];
      return thumbnail?.url || null;
    }
    // Fallback to image_url if available
    if (topic.image_url) {
      return topic.image_url;
    }
    return null;
  }

  <template>
    <aside class="discovery-sidebar discovery-sidebar-recents" {{positionFixedToColumn}}>
      <div class="discovery-sidebar__content">
        <h3>Recently Viewed</h3>
        {{#if this.recentTopics.length}}
          <ul class="discovery-sidebar-recents__list">
            {{#each this.recentTopics as |topic|}}
              <li class="discovery-sidebar-recents__item">
                <a href="/t/{{topic.slug}}/{{topic.id}}" class="discovery-sidebar-recents__card">
                  <div class="discovery-sidebar-recents__info">
                    <div class="discovery-sidebar-recents__header">
                      {{#if topic.user}}
                        <span class="discovery-sidebar-recents__avatar">
                          {{avatar topic.user imageSize="tiny"}}
                        </span>
                        <span class="discovery-sidebar-recents__meta">
                          <span class="discovery-sidebar-recents__username">{{topic.user.username}}</span>
                          <span class="discovery-sidebar-recents__separator">•</span>
                          <span class="discovery-sidebar-recents__age">{{ageWithTooltip topic.created_at}}</span>
                        </span>
                      {{/if}}
                    </div>
                    <h4 class="discovery-sidebar-recents__title">{{topic.fancy_title}}</h4>
                    <div class="discovery-sidebar-recents__stats">
                      {{#if topic.post_votes_first_post_count}}
                        <span class="discovery-sidebar-recents__stat">{{topic.post_votes_first_post_count}} upvotes</span>
                        <span class="discovery-sidebar-recents__separator">•</span>
                      {{/if}}
                      <span class="discovery-sidebar-recents__stat">{{topic.reply_count}} comments</span>
                    </div>
                  </div>
                  {{#if (this.getThumbnailUrl topic)}}
                    <div class="discovery-sidebar-recents__thumbnail">
                      <img src={{this.getThumbnailUrl topic}} alt="" loading="lazy" />
                    </div>
                  {{/if}}
                </a>
              </li>
            {{/each}}
          </ul>
        {{else}}
          <p>No recently viewed topics</p>
        {{/if}}
      </div>
    </aside>
  </template>
}
