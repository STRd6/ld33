(function(pkg) {
  (function() {
  var annotateSourceURL, cacheFor, circularGuard, defaultEntryPoint, fileSeparator, generateRequireFn, global, isPackage, loadModule, loadPackage, loadPath, normalizePath, rootModule, startsWith,
    __slice = [].slice;

  fileSeparator = '/';

  global = window;

  defaultEntryPoint = "main";

  circularGuard = {};

  rootModule = {
    path: ""
  };

  loadPath = function(parentModule, pkg, path) {
    var cache, localPath, module, normalizedPath;
    if (startsWith(path, '/')) {
      localPath = [];
    } else {
      localPath = parentModule.path.split(fileSeparator);
    }
    normalizedPath = normalizePath(path, localPath);
    cache = cacheFor(pkg);
    if (module = cache[normalizedPath]) {
      if (module === circularGuard) {
        throw "Circular dependency detected when requiring " + normalizedPath;
      }
    } else {
      cache[normalizedPath] = circularGuard;
      try {
        cache[normalizedPath] = module = loadModule(pkg, normalizedPath);
      } finally {
        if (cache[normalizedPath] === circularGuard) {
          delete cache[normalizedPath];
        }
      }
    }
    return module.exports;
  };

  normalizePath = function(path, base) {
    var piece, result;
    if (base == null) {
      base = [];
    }
    base = base.concat(path.split(fileSeparator));
    result = [];
    while (base.length) {
      switch (piece = base.shift()) {
        case "..":
          result.pop();
          break;
        case "":
        case ".":
          break;
        default:
          result.push(piece);
      }
    }
    return result.join(fileSeparator);
  };

  loadPackage = function(pkg) {
    var path;
    path = pkg.entryPoint || defaultEntryPoint;
    return loadPath(rootModule, pkg, path);
  };

  loadModule = function(pkg, path) {
    var args, context, dirname, file, module, program, values;
    if (!(file = pkg.distribution[path])) {
      throw "Could not find file at " + path + " in " + pkg.name;
    }
    program = annotateSourceURL(file.content, pkg, path);
    dirname = path.split(fileSeparator).slice(0, -1).join(fileSeparator);
    module = {
      path: dirname,
      exports: {}
    };
    context = {
      require: generateRequireFn(pkg, module),
      global: global,
      module: module,
      exports: module.exports,
      PACKAGE: pkg,
      __filename: path,
      __dirname: dirname
    };
    args = Object.keys(context);
    values = args.map(function(name) {
      return context[name];
    });
    Function.apply(null, __slice.call(args).concat([program])).apply(module, values);
    return module;
  };

  isPackage = function(path) {
    if (!(startsWith(path, fileSeparator) || startsWith(path, "." + fileSeparator) || startsWith(path, ".." + fileSeparator))) {
      return path.split(fileSeparator)[0];
    } else {
      return false;
    }
  };

  generateRequireFn = function(pkg, module) {
    if (module == null) {
      module = rootModule;
    }
    if (pkg.name == null) {
      pkg.name = "ROOT";
    }
    if (pkg.scopedName == null) {
      pkg.scopedName = "ROOT";
    }
    return function(path) {
      var otherPackage;
      if (isPackage(path)) {
        if (!(otherPackage = pkg.dependencies[path])) {
          throw "Package: " + path + " not found.";
        }
        if (otherPackage.name == null) {
          otherPackage.name = path;
        }
        if (otherPackage.scopedName == null) {
          otherPackage.scopedName = "" + pkg.scopedName + ":" + path;
        }
        return loadPackage(otherPackage);
      } else {
        return loadPath(module, pkg, path);
      }
    };
  };

  if (typeof exports !== "undefined" && exports !== null) {
    exports.generateFor = generateRequireFn;
  } else {
    global.Require = {
      generateFor: generateRequireFn
    };
  }

  startsWith = function(string, prefix) {
    return string.lastIndexOf(prefix, 0) === 0;
  };

  cacheFor = function(pkg) {
    if (pkg.cache) {
      return pkg.cache;
    }
    Object.defineProperty(pkg, "cache", {
      value: {}
    });
    return pkg.cache;
  };

  annotateSourceURL = function(program, pkg, path) {
    return "" + program + "\n//# sourceURL=" + pkg.scopedName + "/" + path;
  };

}).call(this);

//# sourceURL=main.coffee
  window.require = Require.generateFor(pkg);
})({
  "source": {
    "LICENSE": {
      "path": "LICENSE",
      "content": "The MIT License (MIT)\n\nCopyright (c) 2015 Daniel X Moore\n\nPermission is hereby granted, free of charge, to any person obtaining a copy\nof this software and associated documentation files (the \"Software\"), to deal\nin the Software without restriction, including without limitation the rights\nto use, copy, modify, merge, publish, distribute, sublicense, and/or sell\ncopies of the Software, and to permit persons to whom the Software is\nfurnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all\ncopies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\nFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\nAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\nOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\nSOFTWARE.\n\n",
      "mode": "100644",
      "type": "blob"
    },
    "README.md": {
      "path": "README.md",
      "content": "# ld33\nLudum Dare 33: You are the monster\n",
      "mode": "100644",
      "type": "blob"
    },
    "main.coffee": {
      "path": "main.coffee",
      "content": "# Canvas where we draw our duders\n# Text box where we display dialog\n# Options to choose from\n# Moving around\n# Triggered events\n# Die Hard Quotes\n\n# Wall Sprites\n# Chair Sprites\n# TV Sprites\n# Goblin Sprites\n# Ogre Sprites\n# Hero Sprites\n\n# 3 Goblins sitting in a room in a dungeon\n# Chillin, watching Die Hard\n# Adevnturers come in and try to wreck up the place\n# Lvl 1 Cleric\n# Goblins kill the poor bastard\n# A two headed ogre want's to borrow some rock salt to add to Bud LightTM\n# Lime-A-Ritas\n# The ogre also wants to stay and watch die hard\n# YOU DECIDE\n# Lvl 4 Fighter\n\n# Talking to Steve\n# STEVE: \"Remember that project I was really excited about... well BOSS says I\n# Shouldn't work on it any more... so forget it.\"\n\n# There is a chest in the room, if you try to open it steve says: Boss told us \n# not to mess into that.\n# Chest contians healing elixir and broken cassette tape\n# They don't keep the Hard-A in Lvl 1 loot tables\n\n# Wait, so do we work here, or is this the break room, because I've always \n# thought it was the break room... That Craig's List add wasn't very specific\n# - Steve\n\n# There is a rock trap if you try to leave the room\n# Steve will say: Boss says to stay in here\n# The rock trap will kill you\n\n# Achievements:\n# Die Hard: With a Vengance - Watch all of Die Hard\n# Hard Hat Warning - Died to a rock trap\n# A Winner is You - Survived all Encounters\n\n# OGRE: \"This is our house!\"\n# OGRE: \"You're going DOWN scrote sac!\"\n# YOU: \"So is a scrote sac like a scrotum, or a sack of scrotums?\"\n# Ogre kills fighter\n\n# Lvl 7 Gladiator\n# Axe rends Steve in twain\n# CARL: \"Steve's dead man...\"\n# Carl doesn't speak for the rest of the game, sits in the corner '...'\n\n# After the gladiator encounter the rock trap will be trigered and you can\n# go out and find another room with some swank loot (wand of death).\n\n# Lvl 10 Thief\n# Use wand of death to kill thief\n\n# Lvl 13 mage\n# Burns the place to shit\n# Hell Spawn then enters and kills Mage\n\n# Grab orb of Zot\n# Show orb to Ogre\n# Ogre drops it and it shatters\n# Messenger comes to tell Steve that his project is back on!\n# Steve's dead man...\n# G_G\n\nalert 'yolo'",
      "mode": "100644"
    }
  },
  "distribution": {
    "main": {
      "path": "main",
      "content": "(function() {\n  alert('yolo');\n\n}).call(this);\n",
      "type": "blob"
    }
  },
  "progenitor": {
    "url": "http://www.danielx.net/editor/"
  },
  "entryPoint": "main",
  "repository": {
    "branch": "master",
    "default_branch": "master",
    "full_name": "STRd6/ld33",
    "homepage": null,
    "description": "Ludum Dare 33: You are the monster",
    "html_url": "https://github.com/STRd6/ld33",
    "url": "https://api.github.com/repos/STRd6/ld33",
    "publishBranch": "gh-pages"
  },
  "dependencies": {}
});