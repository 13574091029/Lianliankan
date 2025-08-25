'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "bb70732f2e6de2b5760b471b84d7b4c1",
"version.json": "06c4bb207e440eaf039b301753d5fc46",
"index.html": "d10627c1a7a7c9faecdd77eb5f6da06b",
"/": "d10627c1a7a7c9faecdd77eb5f6da06b",
"main.dart.js": "51ea5eca4bc0232b6f70b608f23b6ec1",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "61f7b4f20bf896523368158e23b41b1d",
"assets/AssetManifest.json": "82c2638f278e72088dccf76deb6a51fd",
"assets/NOTICES": "9b284786d4594f0a2d7933a67973e9d5",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "709c89e117d80b3947cf8a1d730bb4ee",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "82bf115aa5c7cae289631ef242c48b6d",
"assets/fonts/MaterialIcons-Regular.otf": "b71270d1e9b2820db5600d847c15d84b",
"assets/assets/sounds/click.mp3": "a252b6a1c1a7e07f7ba0f4226db3112b",
"assets/assets/sounds/correct.mp3": "46f7a472b621ccef5488c250b41e6f83",
"assets/assets/icons/tangguo1.png": "03be2c7ad84ddab894ab5c3ad72e0058",
"assets/assets/icons/starfish.png": "147ba14ddf98d7d101127814fd069a25",
"assets/assets/icons/xigua.png": "ffbdb0b401ec4adefc84bc7cc82d62f4",
"assets/assets/icons/jinglingdan.png": "0d5d69901191e76f645b1aa8da3769a4",
"assets/assets/icons/yinghua.png": "f695a64df2321b323844800429a9f19a",
"assets/assets/icons/huolongguo.png": "1d3a2795e07ea6f0c09dfae17a5959a1",
"assets/assets/icons/octopus.png": "0dc5f22f68ea4f20b3c69fab96ccfc2b",
"assets/assets/icons/shizhong.png": "b5b4cf38702d49e6b9edf2e12179c315",
"assets/assets/icons/huifudian2.png": "8b084c0910eef7b9ca46d56e033a9878",
"assets/assets/icons/chip.png": "b1b8e042887ad5673a0eaaea162d5abb",
"assets/assets/icons/rollpan.png": "47bac6a8fc300ad73fe10d00383639ef",
"assets/assets/icons/expression_26.png": "22580634fb4c14bffc2ab8f5921fea70",
"assets/assets/icons/milk.png": "286798d3eb4eed0221738623184f3c15",
"assets/assets/icons/butterfly.png": "20bcd8aaecc53b31a58bebc4e9426e81",
"assets/assets/icons/yujinxiang.png": "a0f7843a97f91ceb943a12f170c6e7ab",
"assets/assets/icons/expression_25.png": "0b94ae05acea6d7490a48d67ecca2ca2",
"assets/assets/icons/shengdanmao.png": "82fc55cf1ee383055e879d68e2e22973",
"assets/assets/icons/expression_15.png": "c6f04e6387653ccd639b5b897fe15381",
"assets/assets/icons/xuehua.png": "5309964802dfe0ee69cdafbb299758d4",
"assets/assets/icons/cat.png": "7944f575f706e1f5d9af90a30d8b5ff1",
"assets/assets/icons/jinglingdan1.png": "54606a5bbd132fd55ff4ed0743ab4660",
"assets/assets/icons/ningmeng.png": "af3b75c331182c799f0e274660dec55e",
"assets/assets/icons/expression_17.png": "b4ba5b905c492eadd823b95fe29f9ac2",
"assets/assets/icons/catfoot.png": "e3819bcde831d977668742d34c7c47d6",
"assets/assets/icons/psyduck.png": "575127858d4b3c0fa866ae5e87487f31",
"assets/assets/icons/xingyundan.png": "6449cfcbc031fcf6ac393a25d1d03e2d",
"assets/assets/icons/jinglingqiu.png": "9ca9c0f43f3e894236e71882b2a9c0d7",
"assets/assets/icons/icecream.png": "708a4271cbde3f939c61f3f89366a606",
"assets/assets/icons/mihoutao.png": "6f3160b1e40412ede3425c9e59af6891",
"assets/assets/icons/li.png": "816e261b8ec4980354dbe8f630bc444d",
"assets/assets/icons/guaizhang.png": "9bdd3b63d55a3f815362ad3454cf9b42",
"assets/assets/icons/tangguo.png": "cc33a56afb791051d591fd5eb93a996e",
"assets/assets/icons/egg.png": "9ccc9abcec8adce096b253aca31a6e15",
"assets/assets/icons/pingguo.png": "f03f16ffb2bbb206eebf552e3d912b93",
"assets/assets/icons/huifudian.png": "70e712bf7cee9dd6a6909f5b8c4dd761",
"assets/assets/icons/chocolate.png": "fbeb9ac4942f40e9ef6ef192c81b8db0",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
