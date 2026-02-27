import Component from "@glimmer/component";
import { htmlSafe } from "@ember/template";
import { service } from "@ember/service";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import formatDateAlwaysRelative from "../helpers/format-date-always-relative";

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

  getPoster = (topic) => {
    return topic.posters?.[0] || null;
  }

  getAvatarUrl = (topic) => {
    const poster = this.getPoster(topic);
    if (!poster?.avatar_template) {
      return null;
    }
    // Replace {size} placeholder with actual size (48px)
    return poster.avatar_template.replace("{size}", "48");
  }

  getUsername = (topic) => {
    const poster = this.getPoster(topic);
    return poster?.username || "";
  }

  getThumbnailUrl = (topic) => {
    if (topic.thumbnails && topic.thumbnails.length > 0) {
      const displaySize = 80;
      const pixelRatio = window.devicePixelRatio || 1;
      const targetSize = displaySize * Math.min(pixelRatio, 2);

      const thumbnail = topic.thumbnails.find(t => t.max_width >= targetSize)
                     || topic.thumbnails[topic.thumbnails.length - 1];
      return thumbnail?.url || null;
    }
    return null;
  }

  getCommentCount = (topic) => {
    // posts_count includes the OP, so subtract 1 to get only comments (posts + replies)
    return Math.max(0, (topic.posts_count || 0) - 1);
  }

  pluralize = (count, word) => {
    return Math.abs(count) === 1 ? word : `${word}s`;
  }

  <template>
    <aside class="discovery-sidebar discovery-sidebar-recents">
      <div class="discovery-sidebar__content">
        <h3>Recently Viewed</h3>
        {{#if this.recentTopics.length}}
          <ul class="discovery-sidebar-recents__list">
            {{#each this.recentTopics as |topic|}}
              <li class="discovery-sidebar-recents__item">
                <a href="/t/{{topic.slug}}/{{topic.id}}" class="discovery-sidebar-recents__card">
                  <div class="discovery-sidebar-recents__top">
                    <div class="discovery-sidebar-recents__info">
                      {{#if (this.getPoster topic)}}
                        <div class="discovery-sidebar-recents__header">
                          <span class="discovery-sidebar-recents__avatar">
                            <img src={{this.getAvatarUrl topic}} alt={{this.getUsername topic}} class="avatar" loading="lazy" />
                          </span>
                          <span class="discovery-sidebar-recents__meta">
                            <span class="discovery-sidebar-recents__username">{{this.getUsername topic}}</span>
                            <span class="discovery-sidebar-recents__separator">•</span>
                            <span class="discovery-sidebar-recents__age">{{formatDateAlwaysRelative topic.created_at}}</span>
                          </span>
                        </div>
                      {{/if}}
                      <h4 class="discovery-sidebar-recents__title">{{htmlSafe topic.fancy_title}}</h4>
                    </div>
                    {{#if (this.getThumbnailUrl topic)}}
                      <div class="discovery-sidebar-recents__thumbnail">
                        <img src={{this.getThumbnailUrl topic}} alt="" loading="lazy" />
                      </div>
                    {{/if}}
                  </div>
                  <div class="discovery-sidebar-recents__stats">
                    <span class="discovery-sidebar-recents__stat">{{topic.post_votes_first_post_count}} {{this.pluralize topic.post_votes_first_post_count "upvote"}}</span>
                    <span class="discovery-sidebar-recents__separator">•</span>
                    <span class="discovery-sidebar-recents__stat">{{this.getCommentCount topic}} {{this.pluralize (this.getCommentCount topic) "comment"}}</span>
                  </div>
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
