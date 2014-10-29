;(function($, Shopify, window, document, undefined) {

  // Define the Locales module, which will be exported.
  var Locales = {};

  // Hash for storing locale data retrieved by Ajax.
  var _locales = {};

  // The default locale.
  var _defaultLocale = null;

  // The default locale asset URL.
  var _defaultLocaleAssetUrl = null;

  /**
   * Get the URL to an locale's JSON asset, based on the default locale asset URL.
   *
   * @param locale
   */
  function getLocaleAssetUrl(locale) {
    return _defaultLocaleAssetUrl.replace(_defaultLocale + '.json', locale + '.json');
  }

  /**
   * Initialise the Locales module.
   *
   * @param defaultLocale
   * @param defaultLocaleAssetUrl
   */
  function init(defaultLocale, defaultLocaleAssetUrl) {
    // Store default locale settings.
    _defaultLocale = defaultLocale;
    _defaultLocaleAssetUrl = defaultLocaleAssetUrl;

    // Create event listeners on the document.
    $(document).on('change', '[data-update="locale"]', function() {
      var $this = $(this), locale = $this.val();

      // If we already have the locale information stored, just translate directly.
      if(_locales[locale] !== undefined) {
        translatePage(locale);
        return;
      }

      // Fetch the locale's asset information.
      $.getJSON(getLocaleAssetUrl(locale), function(localeData) {
        // Store the returned locale data.
        _locales[locale] = localeData;

        // Perform a translation of the whole page.
        translatePage(locale);
      });
    });
  }

  /**
   * Get a translation from a dot-notated keypath.
   * This currently uses evil eval().
   *
   * @param keyPath
   * @param locale
   */
  function getTranslation(keyPath, locale) {
    return eval('_locales.' + locale + '.' + keyPath);
  }

  /**
   * Translate a specific element to the given locale.
   *
   * @param element
   * @param locale
   */
  function translateElement(element, locale) {
    var $element = $(element),
        keyPath = $element.data('translate');

    $(element).text(getTranslation(keyPath, locale));
  }

  /**
   * Translate all elements on the page marked up with data-translate attributes to the given locale.
   *
   * @param locale
   */
  function translatePage(locale) {
    $('[data-translate]').each(function(i, element) {
      translateElement(element, locale);
    });
  }

  // Export public methods and the module itself.
  Locales.init = init;
  Locales.translatePage = translatePage;
  Shopify.Locales = Locales;

})(jQuery, Shopify || {}, window, document);
