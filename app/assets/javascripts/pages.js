$(document).on("turbolinks:load", function () {

  if (CodeCentral.page() === "pages#dashboard") {
    var createLegend = function (chart) {
      var html = [];
      html.push('<div>');
      for (var i = 0; i < chart.data.datasets[0].data.length; i++) {
        html.push('<div>');
        html.push('<span class="chart-legend-color" style="background-color: ' + chart.data.datasets[0].backgroundColor[i] + '">&nbsp;</span>');
        html.push(chart.data.labels[i]);
        html.push('</div>');
      }
      html.push('</div>');
      return html.join("");
    };

    var chart = function (ctx, labels, data) {
      var backgroundColor = ["#4773aa", "#f9c642"];
      return new Chart(ctx, {
        type: "pie",
        data: {
          labels: labels,
          datasets: [{ data: data, backgroundColor: backgroundColor }]
        },
        options: {
          legendCallback: createLegend,
          legend: {
            display: false
          }
        }
      });
    };

    var opennessChart = chart($("#project-openness-chart"),
      [$("#open-source-label").text(), $("#closed-source-label").text()],
      [$("#open-source-value").text(), $("#closed-source-value").text()]);
    $("#project-openness-legend").html(opennessChart.generateLegend());

    var reuseChart = chart($("#project-reuse-chart"),
      [$("#reuse-label").text(), $("#non-reuse-label").text()],
      [$("#reuse-value").text(), $("#non-reuse-value").text()]);
    $("#project-reuse-legend").html(reuseChart.generateLegend());
  }

});
