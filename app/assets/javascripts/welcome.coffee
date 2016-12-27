App = {}

class App
  constructor: ->
    console.log "New App..."
  
  start: =>
    jobs = @getCollection()
    console.log 'Collection: ', jobs

    $('.btn').on 'click', =>
      dino = new ListRenderer(jobs, $('ul'))
      dino.render()

  getCollection: ->
    [ { id: 5 }, { id: 6 }, { id: 7 } ]
    [ { id: 0 }, { id: 5 }, { id: 6 }, { id: 8 }, { id: 9 }, { id: 11 }, { id: 13 }, { id: 18 } ]
    [ { id: 0 }, { id: 1 }, { id: 2 }, { id: 3 }, { id: 4 }, { id: 6 }, { id: 8 }, { id: 9 }, { id: 11 }, { id: 13 }, { id: 18 } ]
    [ { id: 0 }, { id: 1 }, { id: 2 }, { id: 3 }, { id: 4 }, { id: 6 }, { id: 8 }, { id: 9 }, { id: 11 }, { id: 13 } ]

class ListRenderer
  constructor: (@collection, @list) ->
    @lis = @list.find 'li'
    @prepare()

  prepare: ->
    head = 0
    new_head = 0
    objects = []
    @additions = []
    @removals = $()

    # for li in @lis
    #   $(li).css 'height', "#{$(li).outerHeight()}px"

    for o in @collection
      temp = []
      for i in [head..@lis.length - 1]
        li = @lis[i]
        if $(li).data('id') is o.id
          @removals = @removals.add(temp) if temp.length > 0
          
          new_head = i + 1
          break unless o is @collection[@collection.length-1]
        else
          temp.push li

      if new_head != head # found
        head = new_head
        head_li = if head > 1 then $(@lis[head-2]) else null
        @additions.push { head: head_li, elems: objects } if objects.length > 0
        objects = []
      else # not found
        objects.push o

    if objects.length > 0
      @additions.push { elems: objects }
    @removals = @removals.add(temp) if temp.length > 0
    console.log 'additions: ', @additions
    console.log 'removals: ', @removals

  render: =>
    for addition in @additions
      switch addition.head
        when null
          for e in addition.elems
            @list.prepend(@createItem e)
        when undefined
          for e in addition.elems
            @list.append(@createItem e)
        else
          for e in addition.elems
            addition.head.after(@createItem e)

    @removals.addClass 'deleted'
    setTimeout (() =>
      @removals.css 'height', '0px'
      @removals.addClass('removed')
      setTimeout (() =>
        @removals.remove()),
        500),
      500

  createItem: (o) ->
    "<li data-id=#{o.id}>Item number #{o.id}</li>"

$ ->
  app = new App()
  app.start()
