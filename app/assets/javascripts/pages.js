$(document).on("turbolinks:load", function () {

  if (CodeCentral.page() === "pages#dashboard") {

    var chart = function (datasetName) {
      var $datasetSource = $("table[data-dataset='" + datasetName + "']");
      var $canvas = $(".chart[data-dataset='" + datasetName + "']");
      var backgroundColor = ["#4773aa", "#f9c642"];
      var labels = [];
      var values = [];
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
          datasets: [{ data: values, backgroundColor: backgroundColor }]
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
