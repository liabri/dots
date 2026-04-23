// privacy
user_pref("privacy.fingerprintingProtection", true);
user_pref("privacy.globalprivacycontrol.enabled", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.trackingprotection.emailtracking.enabled", true);

// networking
user_pref("network.dns.disablePrefetch", true);
user_pref("network.prefetch-next", false);
user_pref("network.http.speculative-parallel-limit", 0);

// ui
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.toolbars.bookmarks.visibility", "never");
user_pref("browser.startup.page", 3);
user_pref("sidebar.revamp", false);
user_pref("sidebar.visibility", "hide-sidebar");
user_pref("sidebar.main.tools", "");
user_pref("sidebar.new-sidebar.has-used", false);
user_pref("browser.sidebar.disabled", true);
user_pref("layout.css.prefers-color-scheme.content-override", 2);
user_pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org"); // firefox dark theme
user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"ublock0_raymondhill_net-browser-action\",\"addon_darkreader_org-browser-action\",\"_53082585-3a43-4ec7-989c-57d0f23b22da_-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"vertical-spacer\",\"urlbar-container\",\"personal-bookmarks\",\"downloads-button\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"import-button\"]},\"seen\":[\"developer-button\",\"screenshot-button\",\"ublock0_raymondhill_net-browser-action\",\"addon_darkreader_org-browser-action\",\"_53082585-3a43-4ec7-989c-57d0f23b22da_-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"vertical-tabs\",\"PersonalToolbar\",\"toolbar-menubar\",\"TabsToolbar\",\"unified-extensions-area\"],\"currentVersion\":23,\"newElementCount\":17}");

// enable userChrome.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// url bar
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.quickactions", false);
user_pref("browser.urlbar.suggest.topsites", false);

user_pref("browser.urlbar.shortcuts.actions", false);
user_pref("browser.urlbar.shortcuts.bookmarks", false);
user_pref("browser.urlbar.shortcuts.history", false);
user_pref("browser.urlbar.shortcuts.tabs", false);

//misc
user_pref("findbar.highlightAll", true);
user_pref("general.autoScroll", true);
user_pref("media.av1.enabled", false); // i have no device capable of decoding av1
user_pref("ui.key.menuAccessKeyFocuses", false); // so alt doesnt open menu
user_pref("browser.download.dir", "/home/liabri/minzel"); // cannot use env vars for XDG so hardcoded
user_pref("browser.download.folderList", 2);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref("browser.newtabpage.activity-stream.asrouter.providers.cfr", "");
user_pref("signon.generation.enabled", false); // disable strong password suggestions
user_pref("signon.firefoxRelay.feature", "disabled"); // disable firefox relay email suggestions

//drm
user_pref("media.eme.enabled", true);
user_pref("media.gmp-widevinecdm.enabled", true);

// disable pic in pic mode
user_pref("media.videocontrols.picture-in-picture.enabled", false);
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);
user_pref("media.videocontrols.picture-in-picture.video-toggle.always-show", false);

// search engine
user_pref("browser.search.defaultenginename", "DuckDuckGo");
user_pref("browser.search.order.1", "DuckDuckGo");
user_pref("browser.search.hiddenOneOffs", "");

// telemetry
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.usage.uploadEnabled", false);
user_pref("datareporting.healthreport.service.enabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");
user_pref("breakpad.reportURL", "");
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
user_pref("browser.crashReports.unsubmittedCheck.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("browser.ping-centre.telemetry", false);
