require! protractor
#ptor = protractor.getInstance!

const URL = 'http://localhost:3333/'

describe 'ly.g0v.tw' (,) !->
  it 'should automatically redirect to /calendar/today when location hash/fragment is empty' !->
    browser.get URL
    url <-! browser.getCurrentUrl!.then
    expect url .toBe URL + 'calendar/today'

describe 'calendar/today' (,) !->
  it 'should render calendar when user navigates to /calendar/today' !->
    browser.get URL + 'calendar/today'
    expect element(by.className \time).getText! .toMatch /立法院行程/

describe 'bills' !->
  describe 'articles' (,) !->
    # only the following bill has both original and proposed section
    # http://logbot.g0v.tw/channel/g0v.tw/2014-02-07/481
    # but 492 elements are too many to test
    it 'should have labels' !->
      browser.get URL + 'bills/970L19045'
      element
        .all by.xpath "//*[contains(@id, 'original') or contains(@id, 'proposed')]"
        .then !->
          # TODO: speed up getText
          for elem in it => elem.getText!then !->
            expect it .not.toBe \§
            expect it .not.toBe \§undefined
      element.all by.css 'div[ly-diff] .column.left' .then !->
        for elem in it
          expect elem.getAttribute 'class' .not.toMatch /ng-hide/

    it 'left should hidden for baseless bills' !->
      browser.get URL + 'bills/1374L15430'
      element.all by.css 'div[ly-diff] .column.left' .then !->
        for elem in it
          expect elem.getAttribute 'class' .toMatch /ng-hide/

  describe 'sroll spy' (,) !->
    it 'should not scroll back' !->
      browser.get URL + 'bills/956G14876'
      browser.sleep 3000
      browser.executeScript -> scroll 0 20000
      browser.sleep 500
      y = browser.executeScript ->
        current: scroll-y
        max: $(document).height! - $(window).height!
      y.then -> expect it.current .toBe it.max
