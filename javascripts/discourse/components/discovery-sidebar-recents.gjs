import Component from "@glimmer/component";
import { service } from "@ember/service";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import ageWithTooltip from "discourse/helpers/age-with-tooltip";
import positionFixedToColumn from "../modifiers/position-fixed-to-column";

export default class DiscoverySidebarRecents extends Component {
  @service router;
  @service siteSettings;
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

  getPoster(topic) {
    return topic.posters?.[0] || null;
  }

  getAvatarUrl(topic) {
    const poster = this.getPoster(topic);
    if (!poster?.avatar_template) {
      return null;
    }
    // Replace {size} placeholder with actual size (48px)
    return poster.avatar_template.replace("{size}", "48");
  }

  getUsername(topic) {
    const poster = this.getPoster(topic);
    return poster?.username || "";
  }

  getThumbnailUrl(topic) {
    // Try different thumbnail sources
    if (topic.thumbnails && topic.thumbnails.length > 0) {
      // Look for a thumbnail around 200px width
      const thumbnail = topic.thumbnails.find(t => t.max_width >= 200 && t.max_width <= 300)
                     || topic.thumbnails[0];
      return thumbnail?.url || null;
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
                    {{#if (this.getPoster topic)}}
                      <div class="discovery-sidebar-recents__header">
                        <span class="discovery-sidebar-recents__avatar">
                          <img src={{this.getAvatarUrl topic}} alt={{this.getUsername topic}} class="avatar" loading="lazy" />
                        </span>
                        <span class="discovery-sidebar-recents__meta">
                          <span class="discovery-sidebar-recents__username">{{this.getUsername topic}}</span>
                          <span class="discovery-sidebar-recents__separator">•</span>
                          <span class="discovery-sidebar-recents__age">{{ageWithTooltip topic.created_at}}</span>
                        </span>
                      </div>
                    {{/if}}
                    <h4 class="discovery-sidebar-recents__title">{{topic.fancy_title}}</h4>
                    <div class="discovery-sidebar-recents__stats">
                      <span class="discovery-sidebar-recents__stat">{{topic.post_votes_first_post_count}} upvotes</span>
                      <span class="discovery-sidebar-recents__separator">•</span>
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
