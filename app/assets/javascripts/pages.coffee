class PagesController
  init: ->

  stats: ->
    $.ajax('/decisions_chart_data', method: 'get').done( (data) ->
      console.log data

      bar_chart_data = {
        labels: data.labels, # the months on bottom
        datasets: []
      }
      for dts in data.datasets
        bar_chart_data.datasets.push { label: dts.label, backgroundColor: dts.bg_color, data: dts.data }

      ctx = document.getElementById('inviti-decision-chart')
      ctx.height = 500

      myChart = new Chart(ctx, {
        type: 'bar',
        data: bar_chart_data,
        options: {
          tooltips: {
            callbacks: {
              label: (tooltipItem, d) ->
                label = data.datasets[tooltipItem.datasetIndex].label || ''
                if label
                  label += ': '
                v    = tooltipItem.yLabel
                tot  = data.sum_per_month[tooltipItem.index]
                perc = Math.round(v / tot * 100)
                "#{label} #{v} / #{tot} (#{perc}%)"
            }
          },
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
          tooltips: {
            callbacks: {
              label: (tooltipItem, d) ->
                label = data.datasets[tooltipItem.datasetIndex].label || ''
                if label
                  label += ': '
                v    = tooltipItem.yLabel
                tot  = data.sum_per_month[tooltipItem.index]
                perc = Math.round(v / tot * 100)
                "#{label} #{v} / #{tot} (#{perc}%)"
            }
          },
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






  dashboard: ->
    $('ul.sidebar li.nav-item.dashboard').each (el) ->
      $(this).addClass('active')

    $('.dashboard-cards .card').on('click', ->
      url = $(this).data('url')
      Turbolinks.visit(url)
    )



    # $('.dismiss-btn').on('click', ->
    #   url = $(this).data('url')
    #   if url!=""
    #     $.post(url).done ->
    #       alert("hello!")
    # )

this.App.pages = new PagesController
