module UIExplorer exposing
    ( application, defaultConfig, ApplicationConfig, Model, Msg, PageMsg
    , firstPage, nextPage, groupPages, static, Page, PageSize, PageBuilder
    )

{-|


### Create an app that lets you browse and interact with UI you've created.

![example-image](https://raw.githubusercontent.com/insurello/elm-ui-explorer/master/example-image.png)
In this image, the panel to the left is called the sidebar and the page selected in it is shown in the remaining space to the right.

Note that this package is built primarily for UI created with [`mdgriffith/elm-ui`](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/).
You can still use [`elm/html`](https://package.elm-lang.org/packages/elm/html/latest/) with [`Element.html`](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/Element#html) though.


# Application

@docs application, defaultConfig, ApplicationConfig, Model, Msg, PageMsg


# Pages

A "page" is something you can select in the sidebar to display when the app is running.
Pages can contain a single widget, tables showing every variation of your button components, or an entire login page. It's up to you!

@docs firstPage, nextPage, groupPages, static, Page, PageSize, PageBuilder

-}

import Array exposing (Array)
import Browser
import Browser.Dom
import Browser.Events
import Browser.Navigation
import Element exposing (DeviceClass(..), Element)
import Element.Background
import Element.Font
import Element.Input
import Element.Lazy
import Element.Region
import Html exposing (Html)
import Html.Attributes
import Json.Decode as Decode
import Pixels exposing (Pixels)
import Quantity exposing (Quantity)
import Set exposing (Set)
import Svg
import Svg.Attributes
import Task
import Tree exposing (Tree)
import Url exposing (Url)
import Url.Builder
import Url.Parser exposing ((</>))
import Widget exposing (Item)
import Widget.Material as Material
import Widget.Material.Typography as Typography


{-| The first page in your UI explorer. This is the default page if the user doesn't specify a url path.

    import Element
    import UIExplorer

    pages =
        UIExplorer.firstPage
            "My first page"
            (UIExplorer.static (\_ _ -> Element.text "Hi!"))

-}
firstPage : String -> Page model msg flags -> PageBuilder ( (), model ) (PageMsg () msg) flags
firstPage id config =
    PageBuilder
        { init = always ( (), Cmd.none )
        , update = \_ m -> ( m, Cmd.none )
        , view =
            \_ _ _ _ ->
                Element.el
                    [ Element.centerX
                    , Element.centerY
                    , Element.Font.size 28
                    ]
                    (Element.text "Page not found")
        , subscriptions = \_ -> Sub.none
        , ids = []
        , pageGroup = []
        }
        |> nextPage id config


{-| The size of the page your UI gets placed in.
This is not the same as `Browser.Events.resize` since the UI explorer displays a sidebar that can take up some of the window space.

You'll need [`ianmackenzie/elm-units`](https://package.elm-lang.org/packages/ianmackenzie/elm-units/latest/) in order to use `Quantity Int Pixels`.

    import Pixels

    getWidth : PageSize -> Int
    getWidth pageSize =
        Pixels.inPixels pageSize.width

-}
type alias PageSize =
    { width : Quantity Int Pixels, height : Quantity Int Pixels }


{-| All the functions you need for wiring together an interactive page. It's basically just `Browser.element`.

    import MyCoolUi
    import UIExplorer

    loginPage =
        { init = MyCoolUi.loginInit
        , update = MyCoolUi.loginUpdate
        , view = \pageSize model -> MyCoolUi.loginView model
        , subscriptions = always Sub.none
        }

    pages =
        UIExplorer.firstPage "Login Form" loginPage

-}
type alias Page model msg flags =
    { init : flags -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , view : PageSize -> Bool -> model -> Element msg
    , subscriptions : model -> Sub msg
    }


{-| -}
type PageBuilder model msg flags
    = PageBuilder
        { init : flags -> ( model, Cmd msg )
        , update : msg -> model -> ( model, Cmd msg )
        , view : List String -> PageSize -> Bool -> model -> Element msg
        , subscriptions : model -> Sub msg
        , ids : List { pageId : String, pageGroup : List String }
        , pageGroup : List String
        }


{-| A page that doesn't change or react to user input. It's just a view function.
-}
static : (PageSize -> Bool -> flags -> Element msg) -> Page flags msg flags
static pageView =
    { init = \flags -> ( flags, Cmd.none )
    , update = \_ m -> ( m, Cmd.none )
    , view = pageView
    , subscriptions = \_ -> Sub.none
    }


{-| -}
type PageMsg previous current
    = Previous previous
    | Current current


{-| Additional pages in your UI explorer.
You have to start with [`firstPage`](#firstPage) before chaining the result to `nextPage`s.
Each page must also have a unique name.

    import Element
    import UIExplorer

    pages =
        UIExplorer.firstPage
            "My first page"
            (UIExplorer.static (\_ _ -> Element.text "Hi!"))
            |> UIExplorer.nextPage
                "My second page"
                (UIExplorer.static (\_ _ -> Element.none))

-}
nextPage :
    String
    -> Page model msg flags
    -> PageBuilder modelPrevious msgPrevious flags
    -> PageBuilder ( modelPrevious, model ) (PageMsg msgPrevious msg) flags
nextPage id config (PageBuilder previous) =
    let
        init_ : flags -> ( ( modelPrevious, model ), Cmd (PageMsg msgPrevious msg) )
        init_ flags =
            let
                ( previousModel, previousCmds ) =
                    previous.init flags

                ( model, cmds ) =
                    config.init flags
            in
            ( ( previousModel, model ), Cmd.batch [ Cmd.map Previous previousCmds, Cmd.map Current cmds ] )

        update_ :
            PageMsg msgPrevious msg
            -> ( modelPrevious, model )
            -> ( ( modelPrevious, model ), Cmd (PageMsg msgPrevious msg) )
        update_ msg ( previousModel, model ) =
            case msg of
                Previous previousMsg ->
                    let
                        ( newPreviousModel, previousCmds ) =
                            previous.update previousMsg previousModel
                    in
                    ( ( newPreviousModel, model ), Cmd.map Previous previousCmds )

                Current currentMsg ->
                    let
                        ( newModel, cmds ) =
                            config.update currentMsg model
                    in
                    ( ( previousModel, newModel ), Cmd.map Current cmds )

        view_ : List String -> PageSize -> Bool -> ( modelPrevious, model ) -> Element (PageMsg msgPrevious msg)
        view_ pageId windowSize darkTheme ( previousModel, model ) =
            if previous.pageGroup ++ [ id ] == pageId then
                Element.Lazy.lazy3 config.view windowSize darkTheme model |> Element.map Current

            else
                previous.view pageId windowSize darkTheme previousModel |> Element.map Previous

        subscriptions_ ( previousModel, model ) =
            Sub.batch
                [ Sub.map Current (config.subscriptions model)
                , Sub.map Previous (previous.subscriptions previousModel)
                ]
    in
    PageBuilder
        { init = init_
        , update = update_
        , view = view_
        , subscriptions = subscriptions_
        , ids = { pageId = id, pageGroup = previous.pageGroup } :: previous.ids
        , pageGroup = previous.pageGroup
        }


{-| If your list of pages on the sidebar is starting to get too long, you can group some of them together with `groupPages`.

    import MyPages
    import UIExplorer

    flatPages =
        UIExplorer.firstPage "Login" MyPage.login
            |> UIExplorer.nextPage "About us" MyPage.aboutUs
            |> UIExplorer.nextPage "Fonts" MyPage.fonts
            |> UIExplorer.nextPage "Colors" MyPage.colors
            |> UIExplorer.nextPage "Basic components" MyPage.basicComponents
            |> UIExplorer.nextPage "Homepage" MyPage.homepage

    nowItsGrouped =
        UIExplorer.firstPage "Login" MyPage.login
            |> UIExplorer.nextPage "About us" MyPage.aboutUs
            |> UIExplorer.groupPages "Building blocks"
                (UIExplorer.nextPage "Fonts" MyPage.fonts
                    >> UIExplorer.nextPage "Colors" MyPage.colors
                    >> UIExplorer.nextPage "Basic components" MyPage.basicComponents
                )
            |> UIExplorer.nextPage "Homepage" MyPage.homepage

Two things to note:

  - Normally pages need unique names, but with groups it's okay to have two pages use the same name so long as they are in different groups.
  - Due to [`firstPage`](#firstPage) having a different type signature from [`nextPage`](#nextPage), you can't place the first page in a group.
    If this is a problem, [create an issue on github](https://github.com/insurello/elm-ui-explorer/issues/new) explaining your use case.

-}
groupPages : String -> (PageBuilder a0 b0 c0 -> PageBuilder a1 b1 c1) -> PageBuilder a0 b0 c0 -> PageBuilder a1 b1 c1
groupPages groupName pages (PageBuilder pageBuilder) =
    let
        (PageBuilder build) =
            pages (PageBuilder { pageBuilder | pageGroup = pageBuilder.pageGroup ++ [ groupName ] })
    in
    { build | pageGroup = build.pageGroup |> List.reverse |> List.drop 1 |> List.reverse } |> PageBuilder


{-| -}
type Msg pageMsg
    = UrlChanged Url
    | LinkClicked Browser.UrlRequest
    | WindowResized PageSize
    | PressedToggleSidebar
    | ChangeDarkTheme Bool
    | NoOp
    | PageMsg pageMsg
    | PressedChangePageHotkey (List String)
    | ToggledPageGroup (List String)
    | TypingSearchText String
    | PressedClearSearchText
    | PressedPageSizeOption PageSizeOption
    | ToggledPageSizeGroup
    | PressedColorBlindOption (Maybe ColorBlindOption)
    | ToggledColorBlindGroup
    | Load String


type PageSizeOption
    = Iphone5
    | Iphone6
    | IpadVertical
    | IpadHorizontal
    | Native



{- }
   allPageSizeOptions : List PageSizeOption
   allPageSizeOptions =
       [ Iphone5
       , Iphone6
       , IpadVertical
       , IpadHorizontal
       , Native
       ]


   pageSizeOptionToString : PageSizeOption -> String
   pageSizeOptionToString pageSizeOption =
       case pageSizeOption of
           Iphone5 ->
               "iPhone 5/SE"

           Iphone6 ->
               "iPhone 6/7/8"

           IpadVertical ->
               "iPad (vertical)"

           IpadHorizontal ->
               "iPad (horizontal)"

           Native ->
               "Native width"
   -
-}


pageSizeOptionWidth : PageSizeOption -> Maybe (Quantity Int Pixels)
pageSizeOptionWidth pageSizeOption =
    case pageSizeOption of
        Iphone5 ->
            Just (Pixels.pixels 320)

        Iphone6 ->
            Just (Pixels.pixels 375)

        IpadVertical ->
            Just (Pixels.pixels 768)

        IpadHorizontal ->
            Just (Pixels.pixels 1024)

        Native ->
            Nothing


{-| -}
type Model pageModel flags
    = FlagsParsed (SuccessModel pageModel flags)
    | FlagsDidNotParse String


type alias SuccessModel pageModel flags =
    { page : List String
    , key : Browser.Navigation.Key
    , windowSize : PageSize
    , minimizeSidebar : Bool
    , pageModel : pageModel
    , flags : flags
    , expandedGroups : Set String
    , searchText : String
    , expandPageSizeOptions : Bool
    , pageSizeOption : PageSizeOption
    , expandColorBlindOptions : Bool
    , colorBlindOption : Maybe ColorBlindOption
    , darkThemeEnabled : Bool
    }


urlParser : PageBuilder pageModel pageMsg flags -> List String -> Url.Parser.Parser (Maybe (List String) -> b) b
urlParser (PageBuilder pages) rootPath =
    let
        pathParser : List String -> Url.Parser.Parser a a
        pathParser path =
            List.foldl (\segment state -> state </> Url.Parser.s (Url.percentEncode segment)) Url.Parser.top path

        allPagePaths =
            pages.ids
                |> List.map (\{ pageId, pageGroup } -> pageGroup ++ [ pageId ])
                |> List.map (\path -> Url.Parser.map (Just path) (pathParser (rootPath ++ path)))
    in
    Url.Parser.oneOf
        (Url.Parser.map Nothing Url.Parser.top
            :: Url.Parser.map Nothing (pathParser rootPath)
            :: allPagePaths
        )


pageFromUrl : PageBuilder pageModel pageMsg flags -> List String -> Browser.Navigation.Key -> Url -> ( List String, Cmd (Msg pageMsg) )
pageFromUrl (PageBuilder pages) rootPath key url =
    case Url.Parser.parse (urlParser (PageBuilder pages) rootPath) url of
        Just Nothing ->
            case pages.ids |> List.reverse |> List.head of
                Just { pageId, pageGroup } ->
                    ( [], Browser.Navigation.replaceUrl key (uiUrl rootPath (pageGroup ++ [ pageId ])) )

                Nothing ->
                    ( [], Cmd.none )

        Just (Just page) ->
            ( page, Cmd.none )

        Nothing ->
            ( [], Cmd.none )


uiUrl : List String -> List String -> String
uiUrl path pageId =
    Url.Builder.absolute (path ++ List.map Url.percentEncode pageId) []


init :
    ApplicationConfig (Msg pageMsg) flags
    -> PageBuilder pageModel pageMsg flags
    -> Decode.Value
    -> Url
    -> Browser.Navigation.Key
    -> ( Model pageModel flags, Cmd (Msg pageMsg) )
init config (PageBuilder pages) flagsJson url key =
    let
        ( page, navigationCmd ) =
            pageFromUrl (PageBuilder pages) config.relativeUrlPath key url
    in
    case Decode.decodeValue config.flagsDecoder flagsJson of
        Ok flags ->
            let
                ( pageModels, pageCmds ) =
                    pages.init flags
            in
            ( FlagsParsed
                { page = page
                , key = key

                -- We can't know the window size since flags are user defined so we make a guess.
                , windowSize = { width = Pixels.pixels 1920, height = Pixels.pixels 1080 }
                , minimizeSidebar = False
                , flags = flags
                , pageModel = pageModels
                , expandedGroups = expandPage page Set.empty
                , searchText = ""
                , expandPageSizeOptions = False
                , pageSizeOption = Native
                , expandColorBlindOptions = False
                , colorBlindOption = Nothing
                , darkThemeEnabled = False
                }
            , Cmd.batch
                [ navigationCmd
                , Browser.Dom.getViewport
                    |> Task.map
                        (\{ viewport } ->
                            -- The window size should always be integer values so it's safe to round here.
                            { width = Pixels.pixels (round viewport.width)
                            , height = Pixels.pixels (round viewport.height)
                            }
                        )
                    |> Task.perform WindowResized
                , Cmd.map PageMsg pageCmds
                ]
            )

        Err error ->
            ( FlagsDidNotParse (Decode.errorToString error), Cmd.none )


expandPage : List String -> Set String -> Set String
expandPage page expandedGroups =
    page
        |> List.reverse
        |> List.drop 1
        |> List.reverse
        |> List.foldr (\segment state -> [] :: state |> List.map (\a -> segment :: a)) []
        |> List.map pageGroupToString
        |> Set.fromList
        |> Set.union expandedGroups


update :
    PageBuilder pageModel pageMsg flags
    -> ApplicationConfig (Msg pageMsg) flags
    -> Msg pageMsg
    -> Model pageModel flags
    -> ( Model pageModel flags, Cmd (Msg pageMsg) )
update pages config msg model =
    case model of
        FlagsParsed successModel ->
            updateSuccess pages config msg successModel |> Tuple.mapFirst FlagsParsed

        FlagsDidNotParse _ ->
            ( model, Cmd.none )


updateSuccess :
    PageBuilder pageModel pageMsg flags
    -> ApplicationConfig (Msg pageMsg) flags
    -> Msg pageMsg
    -> SuccessModel pageModel flags
    -> ( SuccessModel pageModel flags, Cmd (Msg pageMsg) )
updateSuccess (PageBuilder pages) config msg model =
    case msg of
        UrlChanged url ->
            let
                ( page, pageCmd ) =
                    pageFromUrl (PageBuilder pages) config.relativeUrlPath model.key url
            in
            ( { model | page = page }, pageCmd )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl model.key (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Browser.Navigation.load url
                    )

        NoOp ->
            ( model, Cmd.none )

        WindowResized size ->
            ( { model | windowSize = size }, Cmd.none )

        PressedToggleSidebar ->
            ( { model | minimizeSidebar = not model.minimizeSidebar }, Cmd.none )

        PageMsg pageMsg ->
            let
                ( pageModel, pageCmd ) =
                    pages.update pageMsg model.pageModel
            in
            ( { model | pageModel = pageModel }, Cmd.map PageMsg pageCmd )

        PressedChangePageHotkey pageId ->
            ( model
            , Cmd.batch
                [ Browser.Navigation.pushUrl model.key (uiUrl config.relativeUrlPath pageId)
                , Browser.Dom.focus (pageGroupToString pageId) |> Task.attempt (always NoOp)
                ]
            )

        ToggledPageGroup path ->
            ( { model
                | expandedGroups =
                    let
                        pathString =
                            pageGroupToString path
                    in
                    if Set.member pathString model.expandedGroups then
                        Set.remove pathString model.expandedGroups

                    else
                        Set.insert pathString model.expandedGroups
              }
            , Cmd.none
            )

        TypingSearchText text ->
            ( { model
                | searchText = text
                , expandedGroups =
                    if showSearchResults model.searchText then
                        model.expandedGroups

                    else
                        expandPage model.page model.expandedGroups
              }
            , Cmd.none
            )

        PressedClearSearchText ->
            ( { model
                | searchText = ""
                , expandedGroups = expandPage model.page model.expandedGroups
              }
            , Cmd.none
            )

        PressedPageSizeOption pageSizeOption ->
            ( { model
                | pageSizeOption = pageSizeOption
                , expandPageSizeOptions = False
              }
            , Cmd.none
            )

        ToggledPageSizeGroup ->
            ( { model
                | expandPageSizeOptions = not model.expandPageSizeOptions
                , expandColorBlindOptions = False
              }
            , Cmd.none
            )

        PressedColorBlindOption colorBlindOption ->
            ( { model
                | colorBlindOption = colorBlindOption
                , expandColorBlindOptions = False
              }
            , Cmd.none
            )

        ToggledColorBlindGroup ->
            ( { model
                | expandColorBlindOptions = not model.expandColorBlindOptions
                , expandPageSizeOptions = False
              }
            , Cmd.none
            )

        ChangeDarkTheme enabled ->
            ( { model | darkThemeEnabled = enabled }, Cmd.none )

        Load string ->
            ( model, Browser.Navigation.pushUrl model.key string )


view :
    ApplicationConfig (Msg pageMsg) flags
    -> PageBuilder pageModel pageMsg flags
    -> Model pageModel flags
    -> { title : String, body : List (Html (Msg pageMsg)) }
view config pages model =
    case model of
        FlagsParsed successModel ->
            viewSuccess config pages successModel

        FlagsDidNotParse errorMessage ->
            { title = "Error"
            , body =
                [ Element.layoutWith { options = config.layoutOptions }
                    (Element.width Element.fill
                        :: Element.height Element.fill
                        :: config.layoutAttributes
                    )
                    (errorView False errorMessage)
                ]
            }


textColor : Bool -> Element.Color
textColor dark =
    if dark then
        gray

    else
        Element.rgb255 56 60 67


errorView : Bool -> String -> Element msg
errorView dark errorMessage =
    Element.column
        [ Element.Region.announce
        , Element.width Element.fill
        , Element.Background.color (Element.rgb255 250 237 236)
        , Element.Font.color <| textColor dark
        , Element.padding 16
        , Element.spacing 16
        ]
        [ Element.el [ Element.Font.size 20 ] <| Element.text "Failed to parse flags"
        , Html.div
            [ Html.Attributes.style "white-space" "pre-wrap"
            , Html.Attributes.style "line-height" "1.25"
            , Html.Attributes.style "padding-top" "0"
            , Html.Attributes.style "width" "100%"
            , Html.Attributes.style "word-break" "break-word"
            ]
            [ Html.text errorMessage ]
            |> Element.html
            |> Element.el [ Element.Font.size 16 ]
        ]


viewSuccess :
    ApplicationConfig (Msg pageMsg) flags
    -> PageBuilder pageModel pageMsg flags
    -> SuccessModel pageModel flags
    -> Browser.Document (Msg pageMsg)
viewSuccess config ((PageBuilder pages) as pages_) model =
    let
        {--actualSidebarWidth =
            if model.minimizeSidebar then
                sidebarMinimizedWidth

            else
                sidebarWidth--}
        palette =
            if model.darkThemeEnabled then
                Material.darkPalette

            else
                Material.defaultPalette
    in
    { title = "UI Explorer"
    , body =
        [ Element.layoutWith { options = config.layoutOptions }
            (Element.width Element.fill
                :: (Element.Background.color <|
                        if model.darkThemeEnabled then
                            black

                        else
                            gray
                   )
                :: config.layoutAttributes
            )
            (Element.column [ Element.width Element.fill, Element.height Element.fill ]
                [ Widget.menuBar (Material.menuBar palette)
                    { title =
                        config.sidebarTitle
                            |> Element.el Typography.h6
                    , deviceClass = Desktop
                    , openLeftSheet = Just PressedToggleSidebar
                    , openRightSheet = Nothing
                    , openTopSheet = Nothing
                    , primaryActions = []
                    , search = Nothing
                    }
                , Element.row
                    [ Element.width Element.fill
                    , Element.height Element.fill
                    , Element.behindContent (Element.html colorblindnessSvg)
                    , Element.behindContent (Element.html colorblindnessCss)
                    , Element.Font.color (textColor model.darkThemeEnabled)
                    ]
                    [ -- Element.el [ Element.width (Element.px (Pixels.inPixels actualSidebarWidth)) ] Element.none
                      Element.el
                        [ Element.height <| Element.fill --Element.px (Pixels.inPixels model.windowSize.height)
                        , Element.Font.size 16
                        ]
                        (viewSidebar pages_ config model)
                    , Element.el
                        ([ Element.alignTop
                         , Element.width
                            (case pageSizeOptionWidth model.pageSizeOption of
                                Just width ->
                                    Element.px (Pixels.inPixels width)

                                Nothing ->
                                    Element.fillPortion 999999999
                            )
                         , Element.centerX
                         , Element.paddingXY 0 56
                         , Element.height Element.fill
                         , Element.Region.mainContent
                         , if model.darkThemeEnabled then
                            Element.Background.color <| Element.rgb255 30 30 30

                           else
                            Element.Background.color <| Element.rgb255 225 225 225
                         ]
                            ++ (case model.colorBlindOption of
                                    Nothing ->
                                        []

                                    Just colorBlindOption ->
                                        colorBlindOptionToCssClass colorBlindOption
                                            |> Html.Attributes.class
                                            |> Element.htmlAttribute
                                            |> List.singleton
                               )
                        )
                        (pages.view model.page (contentSize model) model.darkThemeEnabled model.pageModel
                            |> Element.map PageMsg
                        )
                    ]
                ]
            )
        ]
    }


sidebarWidth : Quantity number Pixels
sidebarWidth =
    Pixels.pixels 210


sidebarMinimizedWidth : Quantity number Pixels
sidebarMinimizedWidth =
    Pixels.pixels 16


viewSidebar :
    PageBuilder pageModel pageMsg flags
    -> ApplicationConfig (Msg pageMsg) flags
    -> SuccessModel pageModel flags
    -> Element (Msg pageMsg)
viewSidebar pages config model =
    let
        {--bgColor =
            if model.darkThemeEnabled then
                darkerGray

            else
                lightGray--}
        palette =
            if model.darkThemeEnabled then
                Material.darkPalette

            else
                Material.defaultPalette
    in
    if model.minimizeSidebar then
        Element.none
        {--Element.el
            [ Element.height Element.fill ]
            (Element.Input.button
                [ Element.width (Element.px (Pixels.inPixels sidebarMinimizedWidth))
                , Element.Background.color bgColor
                , Element.height Element.fill
                ]
                { onPress = Just PressedToggleSidebar
                , label = Element.el [ Element.moveRight 3 ] (Element.text "❯")
                }
            )--}

    else
        [ [ Widget.headerItem (Material.fullBleedHeader palette) "Device Toolbar"
          , Widget.insetItem (Material.insetItem palette)
                { text = "Dark Theme"
                , onPress = Just <| ChangeDarkTheme <| not <| model.darkThemeEnabled
                , content =
                    \_ ->
                        Widget.switch (Material.switch palette)
                            { description = "Toggle Theme"
                            , onPress = Just <| ChangeDarkTheme <| not <| model.darkThemeEnabled
                            , active = model.darkThemeEnabled
                            }
                , icon = always Element.none
                }
          ]

        --Having different screen sized is nice, but not very useful in the current implementation.
        --, pageSizeOptionView model.darkThemeEnabled model.expandPageSizeOptions model.pageSizeOption
        --, [ Widget.divider (Material.insetDivider palette) ]
        , colorBlindOptionView model.darkThemeEnabled model.expandColorBlindOptions model.colorBlindOption
        , [ Widget.headerItem (Material.fullBleedHeader palette) "Widgets"
          , Widget.textInput (Material.textInput palette)
                { chips = []
                , text = model.searchText
                , placeholder = Just (Element.Input.placeholder [] (Element.text "Search pages"))
                , label = "Search pages"
                , onChange = TypingSearchText
                }
                |> Element.el [ Element.paddingXY 8 0 ]
                |> Element.el [ Element.height <| Element.px 70, Element.width <| Element.fill ]
                |> Widget.asItem
          , Widget.asItem <|
                if showSearchResults model.searchText then
                    Element.Lazy.lazy5 viewSearchResults model.darkThemeEnabled pages config model.page model.searchText

                else
                    Element.Lazy.lazy5 viewSidebarLinks model.darkThemeEnabled pages config model.page model.expandedGroups
          ]
        ]
            |> List.concat
            |> Widget.itemList (Material.sideSheet palette)



--|> Element.el [ Element.scrollbarY ]


colorblindnessCss : Html msg
colorblindnessCss =
    Html.node "style"
        []
        [ List.map
            (\option ->
                let
                    className =
                        colorBlindOptionToCssClass option
                in
                "." ++ className ++ " { filter: url(#" ++ className ++ ") }\n"
            )
            allColorBlindOptions
            |> String.concat
            |> Html.text
        ]


type ColorBlindOption
    = Protanopia
    | Protanomaly
    | Deuteranopia
    | Deuteranomaly
    | Tritanopia
    | Tritanomaly
    | Achromatopsia
    | Achromatomaly
    | Blind


allColorBlindOptions : List ColorBlindOption
allColorBlindOptions =
    [ Protanopia
    , Protanomaly
    , Deuteranopia
    , Deuteranomaly
    , Tritanopia
    , Tritanomaly
    , Achromatopsia
    , Achromatomaly
    , Blind
    ]


colorBlindOptionToString : ColorBlindOption -> String
colorBlindOptionToString colorBlindOption =
    case colorBlindOption of
        Protanopia ->
            "Protanopia"

        Protanomaly ->
            "Protanomaly"

        Deuteranopia ->
            "Deuteranopia"

        Deuteranomaly ->
            "Deuteranomaly"

        Tritanopia ->
            "Tritanopia"

        Tritanomaly ->
            "Tritanomaly"

        Achromatopsia ->
            "Achromatopsia"

        Achromatomaly ->
            "Achromatomaly"

        Blind ->
            "Blind"


colorBlindOptionToCssClass : ColorBlindOption -> String
colorBlindOptionToCssClass colorBlindOption =
    case colorBlindOption of
        Protanopia ->
            "uie-a"

        Protanomaly ->
            "uie-b"

        Deuteranopia ->
            "uie-c"

        Deuteranomaly ->
            "uie-d"

        Tritanopia ->
            "uie-e"

        Tritanomaly ->
            "uie-f"

        Achromatopsia ->
            "uie-g"

        Achromatomaly ->
            "uie-h"

        Blind ->
            "uie-i"


{-| Values were taken from the page source here: <http://www.rgblind.se/url>.
Search in the DOM for "protanopia" and you should find an SVG tag containing this data.
-}
colorblindnessSvg : Html msg
colorblindnessSvg =
    Svg.svg []
        [ Svg.defs []
            [ Svg.filter
                [ Svg.Attributes.id (colorBlindOptionToCssClass Protanopia) ]
                [ Svg.feColorMatrix
                    [ Svg.Attributes.in_ "SourceGraphic"
                    , Svg.Attributes.values "0.567, 0.433, 0, 0, 0 0.558, 0.442, 0, 0, 0 0, 0.242, 0.758, 0, 0 0, 0, 0, 1, 0"
                    ]
                    []
                ]
            , Svg.filter
                [ Svg.Attributes.id (colorBlindOptionToCssClass Protanomaly) ]
                [ Svg.feColorMatrix
                    [ Svg.Attributes.in_ "SourceGraphic"
                    , Svg.Attributes.values "0.817, 0.183, 0, 0, 0 0.333, 0.667, 0, 0, 0 0, 0.125, 0.875, 0, 0 0, 0, 0, 1, 0"
                    ]
                    []
                ]
            , Svg.filter
                [ Svg.Attributes.id (colorBlindOptionToCssClass Deuteranopia) ]
                [ Svg.feColorMatrix
                    [ Svg.Attributes.in_ "SourceGraphic"
                    , Svg.Attributes.values "0.625, 0.375, 0, 0, 0 0.7, 0.3, 0, 0, 0 0, 0.3, 0.7, 0, 0 0, 0, 0, 1, 0"
                    ]
                    []
                ]
            , Svg.filter
                [ Svg.Attributes.id (colorBlindOptionToCssClass Deuteranomaly) ]
                [ Svg.feColorMatrix
                    [ Svg.Attributes.in_ "SourceGraphic"
                    , Svg.Attributes.values "0.8, 0.2, 0, 0, 0 0.258, 0.742, 0, 0, 0 0, 0.142, 0.858, 0, 0 0, 0, 0, 1, 0"
                    ]
                    []
                ]
            , Svg.filter
                [ Svg.Attributes.id (colorBlindOptionToCssClass Tritanopia) ]
                [ Svg.feColorMatrix
                    [ Svg.Attributes.in_ "SourceGraphic"
                    , Svg.Attributes.values "0.95, 0.05,  0, 0, 0 0,  0.433, 0.567, 0, 0 0,  0.475, 0.525, 0, 0 0,  0, 0, 1, 0"
                    ]
                    []
                ]
            , Svg.filter
                [ Svg.Attributes.id (colorBlindOptionToCssClass Tritanomaly) ]
                [ Svg.feColorMatrix
                    [ Svg.Attributes.in_ "SourceGraphic"
                    , Svg.Attributes.values "0.967, 0.033, 0, 0, 0 0, 0.733, 0.267, 0, 0 0, 0.183, 0.817, 0, 0 0, 0, 0, 1, 0"
                    ]
                    []
                ]
            , Svg.filter
                [ Svg.Attributes.id (colorBlindOptionToCssClass Achromatopsia) ]
                [ Svg.feColorMatrix
                    [ Svg.Attributes.in_ "SourceGraphic"
                    , Svg.Attributes.values "0.299, 0.587, 0.114, 0, 0 0.299, 0.587, 0.114, 0, 0 0.299, 0.587, 0.114, 0, 0 0, 0, 0, 1, 0"
                    ]
                    []
                ]
            , Svg.filter
                [ Svg.Attributes.id (colorBlindOptionToCssClass Achromatomaly) ]
                [ Svg.feColorMatrix
                    [ Svg.Attributes.in_ "SourceGraphic"
                    , Svg.Attributes.values "0.618, 0.320, 0.062, 0, 0 0.163, 0.775, 0.062, 0, 0 0.163, 0.320, 0.516, 0, 0 0, 0, 0, 1, 0"
                    ]
                    []
                ]
            , Svg.filter
                [ Svg.Attributes.id (colorBlindOptionToCssClass Blind) ]
                [ Svg.feColorMatrix
                    [ Svg.Attributes.in_ "SourceGraphic"
                    , Svg.Attributes.values "0, 0, 0, 0, 0 0, 0, 0, 0, 0 0, 0, 0, 0, 0 0, 0, 0, 0, 0"
                    ]
                    []
                ]
            ]
        ]



{--
pageSizeOptionView : Bool -> Bool -> PageSizeOption -> List (Item (Msg pageMsg))
pageSizeOptionView dark isExpanded selectedPageSize =
    optionGroupView dark
        isExpanded
        selectedPageSize
        allPageSizeOptions
        pageSizeOptionToString
        PressedPageSizeOption
        ToggledPageSizeGroup
--}


colorBlindOptionView : Bool -> Bool -> Maybe ColorBlindOption -> List (Item (Msg pageMsg))
colorBlindOptionView dark isExpanded selectedColorBlindOption =
    optionGroupView dark
        isExpanded
        selectedColorBlindOption
        (Nothing :: List.map Just allColorBlindOptions)
        (Maybe.map colorBlindOptionToString >> Maybe.withDefault "No color blindness")
        PressedColorBlindOption
        ToggledColorBlindGroup


optionGroupView : Bool -> Bool -> a -> List a -> (a -> String) -> (a -> msg) -> msg -> List (Item msg)
optionGroupView dark isExpanded selectedItem items itemToString onPress toggleExpand =
    let
        _ =
            if dark then
                darkerGray

            else
                lightBlue

        palette =
            if dark then
                Material.darkPalette

            else
                Material.defaultPalette
    in
    Widget.expansionItem (Material.expansionItem palette)
        { icon = always Element.none
        , text = itemToString selectedItem
        , onToggle = always toggleExpand
        , content =
            List.map
                (\option ->
                    Widget.insetItem (Material.insetItem palette)
                        { text = itemToString option
                        , onPress = onPress option |> Just
                        , icon = always Element.none
                        , content = always Element.none
                        }
                )
                (if isExpanded then
                    items

                 else
                    []
                )
        , isExpanded = isExpanded
        }


showSearchResults : String -> Bool
showSearchResults searchText =
    String.length searchText > 1


viewSearchResults :
    Bool
    -> PageBuilder pageModel pageMsg flags
    -> ApplicationConfig (Msg pageMsg) flags
    -> List String
    -> String
    -> Element (Msg pageMsg)
viewSearchResults dark (PageBuilder pages) config currentPage searchText =
    let
        options : Array { previous : Maybe (List String), current : List String, next : Maybe (List String) }
        options =
            pages.ids
                |> List.filterMap
                    (\{ pageId, pageGroup } ->
                        if
                            String.join " " pageGroup
                                ++ " "
                                ++ pageId
                                |> String.toLower
                                |> String.contains (String.toLower searchText)
                        then
                            pageGroup ++ [ pageId ] |> Just

                        else
                            Nothing
                    )
                |> List.sort
                |> listNeighbors
                |> Array.fromList

        palette =
            if dark then
                Material.darkPalette

            else
                Material.defaultPalette
    in
    Widget.selectItem (Material.selectItem palette)
        { selected =
            options
                |> Array.indexedMap Tuple.pair
                |> Array.filter (Tuple.second >> .current >> (==) currentPage)
                |> Array.get 0
                |> Maybe.map Tuple.first
        , options =
            options
                |> Array.toList
                |> List.filterMap
                    (.current
                        >> List.reverse
                        >> List.head
                        >> Maybe.map
                            (\text ->
                                { text = text
                                , icon = always Element.none
                                }
                            )
                    )
        , onSelect =
            \int ->
                options
                    |> Array.get int
                    |> Maybe.map .current
                    |> Maybe.withDefault []
                    |> uiUrl config.relativeUrlPath
                    |> Load
                    |> Just
        }
        |> Widget.itemList (Material.sideSheet palette)



--|> List.map (pageButton dark config currentPage)


listNeighbors : List a -> List { previous : Maybe a, current : a, next : Maybe a }
listNeighbors list =
    listNeighborsHelper list { previous = Nothing, current = Nothing, next = Nothing } [] |> List.reverse


listNeighborsHelper :
    List a
    -> { previous : Maybe a, current : Maybe a, next : Maybe a }
    -> List { previous : Maybe a, current : a, next : Maybe a }
    -> List { previous : Maybe a, current : a, next : Maybe a }
listNeighborsHelper list { current, next } newList =
    case list of
        head :: rest ->
            let
                newState =
                    { previous = current
                    , current = next
                    , next = Just head
                    }
            in
            case next of
                Just next_ ->
                    listNeighborsHelper rest newState ({ previous = current, current = next_, next = Just head } :: newList)

                _ ->
                    listNeighborsHelper rest newState newList

        [] ->
            case next of
                Just next_ ->
                    { previous = current, current = next_, next = Nothing } :: newList

                Nothing ->
                    newList


contentSize : SuccessModel pageModel flags -> PageSize
contentSize model =
    if model.minimizeSidebar then
        { width =
            pageSizeOptionWidth model.pageSizeOption
                |> Maybe.withDefault model.windowSize.width
                |> Quantity.minus sidebarMinimizedWidth
        , height = model.windowSize.height
        }

    else
        { width =
            pageSizeOptionWidth model.pageSizeOption
                |> Maybe.withDefault model.windowSize.width
                |> Quantity.minus sidebarWidth
        , height = model.windowSize.height
        }


lightBlue : Element.Color
lightBlue =
    Element.rgb255 176 208 225



{--
lightGray : Element.Color
lightGray =
    Element.rgb255 228 234 241
--}


gray : Element.Color
gray =
    Element.rgb255 206 215 225


darkerGray : Element.Color
darkerGray =
    Element.rgb255 20 30 40


black =
    Element.rgb 0 0 0


pageGroupToString : List String -> String
pageGroupToString =
    uiUrl []


type Either
    = TempLeaf String
    | Group { pageId : String, pageGroupHead : String, pageGroup : List String }


buildTree : List { pageId : String, pageGroup : List String } -> List (Tree String)
buildTree items =
    let
        helper : List { pageId : String, pageGroup : List String } -> List (Tree String)
        helper items_ =
            items_
                |> List.map
                    (\item ->
                        case item.pageGroup of
                            head :: rest ->
                                Group { pageId = item.pageId, pageGroupHead = head, pageGroup = rest }

                            [] ->
                                TempLeaf item.pageId
                    )
                |> gatherWith
                    (\a b ->
                        case ( a, b ) of
                            ( Group groupA, Group groupB ) ->
                                groupA.pageGroupHead == groupB.pageGroupHead

                            _ ->
                                False
                    )
                |> List.map
                    (\( head, rest ) ->
                        case head of
                            TempLeaf leaf ->
                                Tree.singleton leaf

                            Group { pageGroupHead } ->
                                (head :: rest)
                                    |> List.filterMap
                                        (\a ->
                                            case a of
                                                Group { pageId, pageGroup } ->
                                                    Just { pageId = pageId, pageGroup = pageGroup }

                                                TempLeaf _ ->
                                                    Nothing
                                        )
                                    |> helper
                                    |> Tree.tree pageGroupHead
                    )
    in
    helper items


viewSidebarLinksHelper :
    Bool
    -> { a | relativeUrlPath : List String }
    -> List String
    -> Set String
    -> List String
    -> List (Tree String)
    -> List (List String)
viewSidebarLinksHelper dark config page expandedGroups path trees =
    trees
        |> List.sortBy Tree.label
        |> List.concatMap
            (\tree ->
                let
                    label : String
                    label =
                        Tree.label tree

                    newPath =
                        path ++ [ label ]
                in
                case Tree.children tree of
                    [] ->
                        [ newPath ]

                    children ->
                        viewSidebarLinksHelper dark config page expandedGroups newPath children
            )


{-| Group equal elements together using a custom equality function. Elements will be
grouped in the same order as they appear in the original list. The same applies to
elements within each group.
gatherWith (==) [1,2,1,3,2]
--> [(1,[1]),(2,[2]),(3,[])]

This code is from <https://github.com/elm-community/list-extra/blob/f3c3c61b7ef85c1b497641f06aae37772674a82e/src/List/Extra.elm#L1943>
It's copied here to avoid a dependency on List.Extra just for a single function.

-}
gatherWith : (a -> a -> Bool) -> List a -> List ( a, List a )
gatherWith testFn list =
    let
        helper : List a -> List ( a, List a ) -> List ( a, List a )
        helper scattered gathered =
            case scattered of
                [] ->
                    List.reverse gathered

                toGather :: population ->
                    let
                        ( gathering, remaining ) =
                            List.partition (testFn toGather) population
                    in
                    helper remaining <| ( toGather, gathering ) :: gathered
    in
    helper list []


viewSidebarLinks :
    Bool
    -> PageBuilder pageModel pageMsg flags
    -> ApplicationConfig (Msg pageMsg) flags
    -> List String
    -> Set String
    -> Element (Msg pageMsg)
viewSidebarLinks dark (PageBuilder pages) config page expandedGroups =
    let
        options : Array (List String)
        options =
            pages.ids
                |> buildTree
                |> viewSidebarLinksHelper dark config page expandedGroups []
                |> Array.fromList

        palette =
            if dark then
                Material.darkPalette

            else
                Material.defaultPalette
    in
    Widget.selectItem (Material.selectItem palette)
        { selected =
            options
                |> Array.indexedMap Tuple.pair
                |> Array.filter (Tuple.second >> (==) page)
                |> Array.get 0
                |> Maybe.map Tuple.first
        , options =
            options
                |> Array.toList
                |> List.filterMap
                    (List.reverse
                        >> List.head
                        >> Maybe.map
                            (\text ->
                                { text = text
                                , icon = always Element.none
                                }
                            )
                    )
        , onSelect =
            \int ->
                options
                    |> Array.get int
                    |> Maybe.withDefault []
                    |> uiUrl config.relativeUrlPath
                    |> Load
                    |> Just
        }
        |> Widget.itemList (Material.sideSheet palette)



{--pages.ids
        |> buildTree
        |> viewSidebarLinksHelper dark config page expandedGroups []
        |> Element.column
            [ Element.width Element.fill
            , Element.Font.medium
            , Element.Font.alignLeft
            ]--}


subscriptions : PageBuilder pageModel pageMsg flags -> Model pageModel flags -> Sub (Msg pageMsg)
subscriptions (PageBuilder pages) model =
    Sub.batch
        [ Browser.Events.onResize
            (\width height ->
                WindowResized
                    { width = Pixels.pixels width, height = Pixels.pixels height }
            )
        , case model of
            FlagsParsed successModel ->
                pages.subscriptions successModel.pageModel |> Sub.map PageMsg

            FlagsDidNotParse _ ->
                Sub.none
        ]


{-| These are settings we can change when creating our UI explorer application.

  - `flagsDecoder` lets us parse json flags we pass to our app. This gets passed along to the init function in our pages (or the view function if you're creating a static page).
  - `layoutOptions` and `layoutAttributes` are used in our app's [Element.layoutWith](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/Element#layoutWith) to control things like the default font or focusStyle.
  - `relativeUrlPath` sets the relative path to pages. `relativeUrlPath = []` makes the page link look like this <https://localhost/MyPage>, and `relativeUrlPath = [ ui, here ]` produces <https://localhost/ui/here/MyPage>

-}
type alias ApplicationConfig msg flags =
    { flagsDecoder : Decode.Decoder flags
    , layoutOptions : List Element.Option
    , layoutAttributes : List (Element.Attribute msg)
    , relativeUrlPath : List String
    , sidebarTitle : Element msg
    }


{-| The default application configuration.

    { flagsDecoder = Decode.succeed ()
    , layoutOptions = []
    , layoutAttributes = []
    , relativeUrlPath = []
    , title = Element.text "UI explorer"
    }

-}
defaultConfig : ApplicationConfig msg ()
defaultConfig =
    { flagsDecoder = Decode.succeed ()
    , layoutOptions = []
    , layoutAttributes = []
    , relativeUrlPath = []
    , sidebarTitle = Element.text "UI explorer"
    }


{-| Here we create our UI explorer app.

    import MyCoolUi
    import UIExplorer

    pages =
        UIExplorer.firstPage
            "Button"
            (UIExplorer.static MyCoolUi.button)
            |> UIExplorer.nextPage
                "Footer"
                (UIExplorer.static MyCoolUi.footer)
            |> UIExplorer.nextPage
                "Login Form"
                { init = MyCoolUi.loginInit
                , update = MyCoolUi.loginUpdate
                , view =
                    \pageSize model ->
                        MyCoolUi.loginView model
                , subscriptions = always Sub.none
                }

    main =
        UIExplorer.application
            UIExplorer.defaultConfig
            pages

Note that we didn't add type signatures for `pages` and `main` in the example.
If we did, we'd have to update it every time we add a new page and the type signatures would get messy.
Instead it's best to just let the compiler infer it automatically.

-}
application :
    ApplicationConfig (Msg pageMsg) flags
    -> PageBuilder pageModel pageMsg flags
    -> Platform.Program Decode.Value (Model pageModel flags) (Msg pageMsg)
application config pages =
    Browser.application
        { init = init config pages
        , view = view config pages
        , update = update pages config
        , subscriptions = subscriptions pages
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
