const puppeteer = require("puppeteer");
const benchPage = require("./benchPage");
const chalk = require("chalk");
var compileToString = require("node-elm-compiler").compileToString;
const fs = require("fs");
const { exec } = require("child_process");

function write_entrypoint(item) {
  const entrypoint = `module Main exposing (main)
import ${item.module}
import Benchmark.Render

main = Benchmark.Render.toProgram ${item.module}.${item.value}
`;
  fs.writeFileSync("./tmp/Main.elm", entrypoint);
}

function regroupResults(results) {
  var regrouped = {};

  for (var i = 0; i < results.length; i++) {
    if (results[i].group) {
      var reorged = {
        name: results[i].name,
        link: results[i].link,
        count: results[i].count,
        fps: results[i].frames.fps,
        timeToFirstPaintMS: results[i].perf.TimeToFirstPaintMS,
        nodes: results[i].perf.Nodes,
        coldRender: {
          layoutSeconds: results[i].perf.LayoutDuration,
          recalcStyleSeconds: results[i].perf.RecalcStyleDuration,
          scriptDurationSeconds: results[i].perf.ScriptDuration,
        },
        warmRender: {
          layoutSeconds: results[i].afterRefresh.LayoutDuration,
          recalcStyleSeconds: results[i].afterRefresh.RecalcStyleDuration,
          scriptDurationSeconds: results[i].afterRefresh.ScriptDuration,
        },
        extendedRender: {
          layoutSeconds: results[i].afterAnimation.LayoutDuration,
          recalcStyleSeconds: results[i].afterAnimation.RecalcStyleDuration,
          scriptDurationSeconds: results[i].afterAnimation.ScriptDuration,
        },
      };
      if (results[i].group in regrouped) {
        regrouped[results[i].group].results.push(reorged);
      } else {
        regrouped[results[i].group] = {
          results: [reorged],
          name: results[i].group,
        };
      }
    }
  }
  return Object.values(regrouped);
}

async function writeResults(allResults, resultsDir, name) {
  if (!fs.existsSync(resultsDir)) {
    fs.mkdirSync(resultsDir);
  }
  var results = JSON.stringify(allResults);
  var template = fs.readFileSync("./runtime/template/viewResults.html");
  // we embed the compiled js to avoid having to start a server to read the app.
  await compileToString(["./src/View/Results.elm"], {
    optimize: true,
  }).then(function (compiled_elm_code) {
    const compiled = eval(`\`${template}\``);
    fs.writeFileSync(`./${resultsDir}/${name}/index.html`, compiled);
  });
}

(async () => {
  const browser = await puppeteer.launch();

  var instances = [
    // { module: "ManyElements", group: "elmUI", count: 1024, value: "elmUI1024" },
    // { module: "ManyElements", group: "elmUI", count: 128, value: "elmUI128" },
    // { module: "ManyElements", group: "elmUI", count: 2048, value: "elmUI2048" },
    // { module: "ManyElements", group: "elmUI", count: 24, value: "elmUI24" },
    // { module: "ManyElements", group: "elmUI", count: 4096, value: "elmUI4096" },
    // { module: "ManyElements", group: "elmUI", count: 8192, value: "elmUI8192" },
    {
      module: "ElmUITwo",
      group: "elmUITwo",
      count: 1024,
      value: "elmUITwo1024",
    },
    {
      module: "ElmUITwo",
      group: "elmUITwo",
      count: 128,
      value: "elmUITwo128",
    },
    {
      module: "ElmUITwo",
      group: "elmUITwo",
      count: 2048,
      value: "elmUITwo2048",
    },
    {
      module: "ElmUITwo",
      group: "elmUITwo",
      count: 24,
      value: "elmUITwo24",
    },
    {
      module: "ElmUITwo",
      group: "elmUITwo",
      count: 4096,
      value: "elmUITwo4096",
    },
    {
      module: "ElmUITwo",
      group: "elmUITwo",
      count: 8192,
      value: "elmUITwo8192",
    },
    // {
    //   module: "ManyElements",
    //   group: "elmUIVCSS",
    //   count: 1024,
    //   value: "elmUIVCSS1024",
    // },
    // {
    //   module: "ManyElements",
    //   group: "elmUIVCSS",
    //   count: 2048,
    //   value: "elmUIVCSS2048",
    // },
    // {
    //   module: "ManyElements",
    //   group: "elmUIVCSS",
    //   count: 24,
    //   value: "elmUIVCSS24",
    // },
    // {
    //   module: "ManyElements",
    //   group: "elmUIVCSS",
    //   count: 4096,
    //   value: "elmUIVCSS4096",
    // },
    // {
    //   module: "ManyElements",
    //   group: "elmUIVCSS",
    //   count: 8192,
    //   value: "elmUIVCSS8192",
    // },
    {
      module: "ManyElements",
      group: "viewHtml",
      count: 1024,
      value: "viewHtml1024",
    },
    {
      module: "ManyElements",
      group: "viewHtml",
      count: 2048,
      value: "viewHtml2048",
    },
    {
      module: "ManyElements",
      group: "viewHtml",
      count: 24,
      value: "viewHtml24",
    },
    {
      module: "ManyElements",
      group: "viewHtml",
      count: 4096,
      value: "viewHtml4096",
    },
    {
      module: "ManyElements",
      group: "viewHtml",
      count: 8192,
      value: "viewHtml8192",
    },
    {
      module: "ManyElements",
      group: "viewInline",
      count: 1024,
      value: "viewInline1024",
    },
    {
      module: "ManyElements",
      group: "viewInline",
      count: 2048,
      value: "viewInline2048",
    },
    {
      module: "ManyElements",
      group: "viewInline",
      count: 24,
      value: "viewInline24",
    },
    {
      module: "ManyElements",
      group: "viewInline",
      count: 4096,
      value: "viewInline4096",
    },
    {
      module: "ManyElements",
      group: "viewInline",
      count: 8192,
      value: "viewInline8192",
    },
  ];

  var dir = "./tmp";
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir);
  }

  var allResults = [];
  const resultsDir = "results";
  const resultName = "1.2-cand";

  if (!fs.existsSync(`./${resultsDir}/${resultName}/instances/`)) {
    fs.mkdirSync(`./${resultsDir}/${resultName}/instances/`, {
      recursive: true,
    });
  }

  console.log(`Beginning benchmark for ${resultName} →`);

  for (var i = 0; i < instances.length; i++) {
    var item = instances[i];
    write_entrypoint(item);

    // Prepare directories
    const jsDir = `${resultsDir}/${resultName}/instances/js`;
    if (!fs.existsSync(jsDir)) {
      fs.mkdirSync(jsDir, { recursive: true });
    }

    const jsCompileDir = `./results/${resultName}/instances/js`;

    // 1. Compile Elm to JS using elm make
    const jsFile = `${jsCompileDir}/${item.value}.js`;
    await new Promise((resolve, reject) => {
      const elmMakeCmd = `elm make --optimize --output=${jsFile} tmp/Main.elm`;
      exec(elmMakeCmd, {}, (error, stdout, stderr) => {
        if (error) reject(error);
        else resolve();
      });
    });

    // 2. Create HTML file
    const htmlFile = `${resultsDir}/${resultName}/instances/${item.value}.html`;
    var template = fs.readFileSync("./runtime/template/run.html", "utf8");

    const compiled = `${template}`.replace(
      "${elm_file_name}",
      `js/${item.value}.js`
    );
    fs.writeFileSync(htmlFile, compiled);

    // 3. Compile Elm to JS using elm-optimize-level-2
    const jsFileOpt2 = `${jsCompileDir}/${item.value}-opt-2.js`;
    await new Promise((resolve, reject) => {
      const elmOptCmd = `elm-optimize-level-2 --output=${jsFileOpt2} tmp/Main.elm`;
      exec(elmOptCmd, {}, (error, stdout, stderr) => {
        if (error) reject(error);
        else resolve();
      });
    });

    // 4. Create HTML file for elm-optimize-level-2 version
    const htmlFileOpt2 = `${resultsDir}/${resultName}/instances/${item.value}-opt-2.html`;
    const compiledOpt2 = `${template}`.replace(
      "${elm_file_name}",
      `js/${item.value}-opt-2.js`
    );
    fs.writeFileSync(htmlFileOpt2, compiledOpt2);

    // Benchmark both versions
    const page = await browser.newPage();
    const results = await benchPage(page, htmlFile);
    results.group = item.group;
    results.count = item.count;
    allResults.push(results);
    await page.close();

    const pageOpt2 = await browser.newPage();
    const resultsOpt2 = await benchPage(pageOpt2, htmlFileOpt2);
    resultsOpt2.group = `${item.group}-opt-2`;
    resultsOpt2.count = item.count;
    allResults.push(resultsOpt2);
    await pageOpt2.close();

    console.log(
      "    Benchmark of " +
        chalk.green(`${item.module}.${item.value}`) +
        " and " +
        chalk.green(`${item.module}.${item.value}-opt-2`) +
        " complete"
    );
  }

  await browser.close();

  allResults = regroupResults(allResults);

  writeResults(allResults, resultsDir, resultName);
  console.log();
  console.log("Benchmark complete");
  console.log("   → " + chalk.green(`${resultsDir}/${resultName}/index.html`));
})();
