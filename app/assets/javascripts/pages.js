$(document).ready(function() {

  if (CodeCentral.page() === "pages#dashboard") {

    var chart = function (datasetName) {
      var $datasetSource = $("table[data-dataset='" + datasetName + "']");
      var $canvas = $(".chart[data-dataset='" + datasetName + "']");
      var chartColors = ["#205493", "#fdb81e", "#2e8540", "#e31c3d", "#02bfe7"];
      var labels = [];
      var values = [];
      $datasetSource.find(".chart-legend-color").each(function (index) {
        $(this).css("background-color", chartColors[index]);
      });
      $datasetSource.find(".chart-label").each(function () {
        labels.push($(this).text());
      });
      $datasetSource.find(".chart-value").each(function () {
        values.push($(this).text());
      });
      return new Chart($canvas, {
        type: "pie",
        data: {
          labels: labels,
          datasets: [{ data: values, backgroundColor: chartColors }]
        },
        options: {
          legend: {
            display: false
          }
        }
      });
    };

    $(".chart").each(function () {
      var datasetName = $(this).data("dataset");
      chart(datasetName);
    });

  }

});
