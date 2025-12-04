# Plan: Fixed Sidebar Theme Component

## Requirements

1. **Content**: Test text for now (placeholder)
2. **Width**: Responsive - fills remaining space not used by cards
3. **Views**: Card-style and compact-style only (from discourse-topic-thumbnails component)
4. **Platform**: Desktop only (hidden on mobile)
5. **Position**: Fixed to right side, uses space NOT taken by cards

## Component Overview

This is a standalone Discourse theme component that adds a fixed sidebar to the topic discovery list when used with the `discourse-topic-thumbnails` component.

### Dependencies
- Requires `discourse-topic-thumbnails` theme component to be installed
- Only activates when card-style or compact-style view is selected

## Implementation Approach

### Layout Strategy

Modify the topic list container to use flexbox layout with:
1. **Main content area** (left): Contains the scrolling cards/compact items
2. **Sidebar** (right): Sticky position, fills remaining horizontal space

### CSS Structure

```
.topic-list (when card/compact with sidebar)
├── display: flex
├── flex-direction: row
├── gap: 1.5em
│
├── .topic-list-body (main content)
│   ├── flex: 0 1 auto
│   └── Contains scrolling cards
│
└── .topic-list-sidebar (NEW - from this component)
    ├── flex: 1
    ├── position: sticky
    ├── top: [header-height]
    ├── min-width: 250px
    ├── max-width: 400px
    └── Test content
```

## File Structure

```
discourse-discovery-sidebar/
├── about.json
├── common/
│   └── common.scss
├── mobile/
│   └── mobile.scss
├── javascripts/
│   └── discourse/
│       ├── components/
│       │   └── discovery-sidebar.gjs
│       └── initializers/
│           └── discovery-sidebar-init.gjs
└── sidebar-implementation.md (this file)
```

## Files to Create

### 1. about.json

Theme component metadata:

```json
{
  "name": "discourse-discovery-sidebar",
  "about_url": null,
  "license_url": null,
  "authors": null,
  "theme_version": "0.1.0",
  "minimum_discourse_version": "3.0.0",
  "component": true,
  "assets": {},
  "color_schemes": {}
}
```

### 2. discovery-sidebar.gjs Component

**File**: `/javascripts/discourse/components/discovery-sidebar.gjs`

```gjs
import Component from "@glimmer/component";

export default class DiscoverySidebar extends Component {
  <template>
    <aside class="discovery-sidebar">
      <div class="discovery-sidebar__content">
        <h3>Sidebar Test</h3>
        <p>This is a test sidebar that stays fixed while scrolling.</p>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
        <p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
      </div>
    </aside>
  </template>
}
```

### 3. Initializer

**File**: `/javascripts/discourse/initializers/discovery-sidebar-init.gjs`

```gjs
import { withPluginApi } from "discourse/lib/plugin-api";
import DiscoverySidebar from "../components/discovery-sidebar";

export default {
  name: "discovery-sidebar-init",

  initialize() {
    withPluginApi("1.14.0", (api) => {
      // Check if topic-thumbnails service exists
      const topicThumbnailsService = api.container.lookup("service:topic-thumbnails");

      if (!topicThumbnailsService) {
        console.warn("discourse-discovery-sidebar requires discourse-topic-thumbnails component");
        return;
      }

      // Inject sidebar when card or compact style is active
      api.renderInOutlet(
        "before-topic-list-body",
        <template>
          {{#if (or topicThumbnailsService.displayCardStyle topicThumbnailsService.displayCompactStyle)}}
            <DiscoverySidebar />
          {{/if}}
        </template>
      );
    });
  },
};
```

### 4. Desktop Styles

**File**: `/common/common.scss`

```scss
// Only apply layout when topic-thumbnails card or compact view is active
.topic-thumbnails-card-style,
.topic-thumbnails-compact {
  // Convert topic list to flex layout for sidebar
  .topic-list {
    display: flex;
    flex-direction: row;
    gap: 1.5em;
    align-items: flex-start;
  }

  .topic-list-body {
    flex: 0 1 auto;
    max-width: 100%;
  }

  // Sidebar styling
  .discovery-sidebar {
    flex: 1 1 auto;
    min-width: 250px;
    max-width: 400px;
    position: sticky;
    top: calc(var(--header-offset, 60px) + 1em);
    align-self: flex-start;
    padding: 1.25em;
    border: 1px solid var(--primary-low);
    border-radius: 0.75em;
    background: var(--secondary);
    max-height: calc(100vh - var(--header-offset, 60px) - 2em);
    overflow-y: auto;
  }

  .discovery-sidebar__content {
    h3 {
      margin: 0 0 0.75em 0;
      font-size: var(--font-up-1);
      color: var(--primary);
      font-weight: 600;
    }

    p {
      margin: 0 0 0.75em 0;
      font-size: var(--font-0);
      color: var(--primary-medium);
      line-height: var(--line-height-large);

      &:last-child {
        margin-bottom: 0;
      }
    }
  }
}

// Hide sidebar on narrower screens to prevent squishing cards
@media (max-width: 1000px) {
  .topic-thumbnails-card-style,
  .topic-thumbnails-compact {
    .discovery-sidebar {
      display: none;
    }

    .topic-list {
      flex-direction: column;
    }

    .topic-list-body {
      flex: 1 1 auto;
    }
  }
}
```

### 5. Mobile Styles

**File**: `/mobile/mobile.scss`

```scss
// Hide sidebar completely on mobile
.topic-thumbnails-card-style,
.topic-thumbnails-compact {
  .discovery-sidebar {
    display: none;
  }

  .topic-list {
    flex-direction: column;
  }

  .topic-list-body {
    flex: 1 1 auto;
  }
}
```

## Implementation Steps

1. Create directory structure and files
2. Create `about.json` with component metadata
3. Create `discovery-sidebar.gjs` component with test content
4. Create initializer to inject sidebar
5. Add desktop styles to `common.scss`
6. Add mobile override styles to `mobile.scss`
7. Test with discourse-topic-thumbnails component installed
8. Verify sidebar appears only in card/compact views
9. Verify sidebar hidden on mobile
10. Verify sticky scroll behavior

## Responsive Behavior

### Desktop (width > 1000px)
- Sidebar appears on right
- Takes remaining space (min: 250px, max: 400px)
- Sticky positioning keeps it visible while scrolling
- Scrolls independently if content is taller than viewport

### Tablet/Narrow Desktop (768px - 1000px)
- Sidebar hidden to prevent squishing cards
- Cards take full width

### Mobile (width < 768px)
- Sidebar completely hidden
- No layout changes

## Integration with discourse-topic-thumbnails

This component:
- Detects the `topic-thumbnails` service
- Only renders when `displayCardStyle` or `displayCompactStyle` is true
- Uses existing class selectors (`.topic-thumbnails-card-style`, `.topic-thumbnails-compact`)
- Modifies layout via CSS without affecting thumbnail component code

## Future Enhancements

1. Add theme settings for sidebar content
2. Support custom widgets/components
3. Add toggle button to show/hide sidebar
4. Save sidebar state to user preferences
5. Add sidebar templates for different content types
6. Make min/max widths configurable

## Testing Checklist

- [ ] Component loads without errors
- [ ] Sidebar appears in card-style view (desktop > 1000px)
- [ ] Sidebar appears in compact-style view (desktop > 1000px)
- [ ] Sidebar does NOT appear in list/grid/masonry views
- [ ] Sidebar hidden on screens < 1000px width
- [ ] Sidebar hidden on mobile
- [ ] Sidebar stays fixed (sticky) while scrolling cards
- [ ] Sidebar scrolls independently if content is tall
- [ ] Cards remain clickable and functional
- [ ] Layout responsive to window resize
- [ ] Works when discourse-topic-thumbnails not installed (graceful fail)
