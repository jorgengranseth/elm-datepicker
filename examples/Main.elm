module Example exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import DatePicker
import Date exposing (Date)
import Task


type alias Model =
    { calendar : DatePicker.DatePicker }


type Msg
    = DatePickerMsg DatePicker.Msg


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , subscriptions = always Sub.none
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( { calendar = DatePicker.initCalendar DatePicker.Single }
    , Cmd.map DatePickerMsg (Task.perform DatePicker.ReceiveDate Date.now)
    )


view : Model -> Html Msg
view model =
    div []
        [ DatePicker.showCalendar model.calendar (DatePicker.getMonth model.calendar) config
            |> Html.map DatePickerMsg
        ]


config : DatePicker.Config
config =
    let
        config =
            DatePicker.defaultConfig
    in
        { config
            | rangeClass = "bg-dark-red white"
            , rangeHoverClass = "bg-dark-red moon-gray"
            , selectedClass = "bg-dark-red white"
            , weekdayFormat = "ddd"
            , validDate = validDate
        }


validDate : Maybe Date -> Maybe Date -> Bool
validDate date currentDate =
    case ( date, currentDate ) of
        ( _, Nothing ) ->
            True

        ( Just date1, Just date2 ) ->
            (Date.toTime date1) > (Date.toTime date2)

        ( Nothing, Just _ ) ->
            False


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DatePickerMsg datePickerMsg ->
            { model | calendar = DatePicker.update datePickerMsg model.calendar } ! []