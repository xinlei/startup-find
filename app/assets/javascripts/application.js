// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require Chart
//= require turbolinks
//= require_tree .

$(document).ready(function() {
    var graph_data = $('.graph_data').data('data');
    var graph_label = $('.graph_label').data('data');

    console.log(graph_data);
    var data = {
        labels: null,
        datasets: [
            {
                label: "Facebook",
                fillColor: "rgba(220,220,220,0.5)",
                strokeColor: "rgba(220,220,220,0.8)",
                highlightFill: "rgba(220,220,220,0.75)",
                highlightStroke: "rgba(220,220,220,1)",
                data: null
            }
        ]
    };
    data["datasets"][0]["data"] = graph_data;
    data["labels"] = graph_label;

    var ctx = $("#chart").get(0).getContext("2d");
    var chart = new Chart(ctx).Bar(data);
});

