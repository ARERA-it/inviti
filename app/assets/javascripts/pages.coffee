class PagesController
  init: ->

  dashboard: ->
    $('ul.sidebar li.nav-item.dashboard').each (el) ->
      $(this).addClass('active')

    $('.dashboard-cards .card').on('click', ->
      url = $(this).data('url')
      Turbolinks.visit(url)
    )

    $.ajax('/decisions_chart_data', method: 'get').done( (data) ->
      console.log data

      bar_chart_data = {
        labels: data.labels,
        datasets: []
      }
      for dts in data.datasets
        bar_chart_data.datasets.push { label: dts.label, backgroundColor: dts.bg_color, data: dts.data }

      ctx = document.getElementById('inviti-decision-chart')
      # console.log ctx
      ctx.height = 500
      myChart = new Chart(ctx, {
        type: 'bar',
        data: bar_chart_data,
        options: {
          scales: {
            xAxes: [{
              stacked: true,
            }]
            yAxes: [{
              stacked: true,
            }]
          },
          responsive: true,
          maintainAspectRatio: false
        }
      })
    ) #


    $.ajax('/appointees_chart_data', method: 'get').done( (data) ->
      console.log data

      bar_chart_data = {
        labels: data.labels,
        datasets: []
      }
      for dts in data.datasets
        bar_chart_data.datasets.push { label: dts.label, backgroundColor: dts.bg_color, data: dts.data }

      ctx = document.getElementById('inviti-appointee-chart')
      # console.log ctx
      ctx.height = 500
      myChart = new Chart(ctx, {
        type: 'bar',
        data: bar_chart_data,
        options: {
          scales: {
            xAxes: [{
              stacked: true,
            }]
            yAxes: [{
              stacked: true,
            }]
          },
          responsive: true,
          maintainAspectRatio: false
        }
      })
    ) #


    # $('.dismiss-btn').on('click', ->
    #   url = $(this).data('url')
    #   if url!=""
    #     $.post(url).done ->
    #       alert("hello!")
    # )

this.App.pages = new PagesController
