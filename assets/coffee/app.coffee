class API
  constructor: (@reddit) ->
  getSubRedditSection: (subReddit, section) ->
    @reddit[section](subReddit)
      # for child in res.data.children
        # console.log child.data
        # container.appendChild(child.data)



class htmlManager
  redditDomain: 'http://www.reddit.com'
  listContainer: document.querySelector('.media-list')
  articleContainer: document.querySelector('.article')
  emptyContainer: document.querySelector('.empty-list')

  showList: -> @listContainer.className = 'show'
  hideList: -> @listContainer.className = 'hide'

  showArticle: -> @articleContainer.className = 'show'
  hideArticle: -> @articleContainer.className = 'hide'

  showEmpty: -> @emptyContainer.className = 'show'
  hideEmpty: -> @emptyContainer.className = 'hide'

  createListItem: (data) ->
    container = document.createElement('div')
    left = document.createElement('div')
    body = document.createElement('div')
    object = @getImg(data.thumbnail)
    obj_link = document.createElement('a')
    title = @getTitle()
    link = document.createElement('a')
    comments = document.createElement('div')

    container.className = 'media'
    left.className = 'media-left'
    body.className = 'media-body'
    object.className = 'media-object'
    title.className = 'media-heading'

    obj_link.setAttribute('href', data.url)
    obj_link.setAttribute('target', '_blank')

    link.setAttribute('href', '/article')
    link.innerText = data.title

    comments.innerText = 'Комментарии: ' + data.num_comments

    obj_link.appendChild(object)
    left.appendChild(obj_link)

    title.appendChild(link)
    body.appendChild(title)
    body.appendChild(@getDate(data.created_utc))
    body.appendChild(@getAuthor(data.author))
    body.appendChild(comments)

    container.appendChild(left)
    container.appendChild(body)

    @listContainer.appendChild(container)

  createArticle: (data) ->
    article = document.createElement('div')
    comments = document.createElement('div')
    comment = document.createElement('div')

    text = document.createElement('div')
    thumbnail = document.createElement('div')
    title = @getTitle()

    article.className = 'row'
    comments.className = 'row'
    comment.className = 'col-md-12'
    text.className = 'col-md-8'
    thumbnail.className = 'col-md-4'

    title.innerText = data.title

    text.appendChild(title)
    text.appendChild(@getAuthor(data.author))
    text.appendChild(@getDate(data.created_utc))
    thumbnail.appendChild(@getImg(data.thumbnail))
    article.appendChild(text)
    article.appendChild(thumbnail)

    comments.appendChild(comment)

    @articleContainer.appendChild(article)
    @articleContainer.appendChild(comments)

  getAuthor: (_author) ->
    author = document.createElement('a')
    author.setAttribute('href', @redditDomain + '/user/' + _author)
    author.setAttribute('target', '_blank')
    author.innerText = _author
    return author

  getDate: (_date) ->
    date = document.createElement('div')
    date.innerText = (new Date(_date*1000)).toLocaleString()
    return date

  getTitle: ->
    title = document.createElement('h4')
    return title

  getImg: (thumbnail) ->
    img = document.createElement('img')
    img.setAttribute('src', thumbnail)
    return img

class Reader
  constructor: ->
    @html = new htmlManager()
    @api = new API(reddit)
    @setRouting()

    # api.getSubRedditSection('aww', 'hot').fetch (res) ->
    #   for child in res.data.children
    #     console.log child.data
    #     html.createListItem(child.data)

  setRouting: ->
    page.base('/')
    page('/', @empty)
    page('/:r/:subreddit', @list)
    page('/article/:id', @article)
    page()

  list: (ctx) =>
    console.log 'list', ctx
    @html.hideArticle()
    @html.hideEmpty()
    @html.showList()
    return

  article: (ctx) =>
    console.log 'article', ctx
    @html.hideList()
    @html.hideEmpty()
    @html.showArticle()
    return

  empty: (ctx) =>
    console.log 'empty', ctx
    @html.hideArticle()
    @html.hideList()
    @html.showEmpty()
    return


new Reader()
