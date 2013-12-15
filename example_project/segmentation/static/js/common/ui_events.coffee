## Common UI helpers

# Helper for hover items
$(document).on('mouseover', '.hover-toggle', ->
  out = $(@).find('.show-on-mouseout')
  over = $(@).find('.show-on-mouseover')
  w = out.width()
  h = out.height()
  out.hide()
  over.width(w)
  over.height(h)
  over.show()
)
$(document).on('mouseout', '.hover-toggle', ->
  $(@).find('.show-on-mouseout').show()
  $(@).find('.show-on-mouseover').hide()
)

# Speedup for categories pages
do ->
  handle_nav = (id) ->
    $("div##{id}").on('click', 'li > a', ->
      $('.loading-spinner').remove()
      $("div##{id} li.active").removeClass('active')
      $(@).closest('li').addClass('active')
      $(@).append(' <i class="icon-spinner icon-spin loading-spinner"></i>')
      timer = setTimeout(( =>
        $('div#content').html('<i class="icon-spinner icon-spin icon-2x"></i>')
      ), 1000)
      window.on('beforeunload', ->
        clearTimeout(timer)
        null
      )
    )

  handle_nav('subnav')
  handle_nav('sidenav')
