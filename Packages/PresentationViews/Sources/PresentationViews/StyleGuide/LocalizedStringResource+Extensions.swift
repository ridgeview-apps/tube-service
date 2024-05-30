import Foundation
import SwiftUI

// swiftlint:disable identifier_name

extension LocalizedStringResource.BundleDescription {
    static let module: Self = { .atURL(Bundle.module.bundleURL) }()
}

// TOD0 - code-generate this file from JSON string catalog

public extension LocalizedStringResource {
    
    private static func moduleResource(_ key: String.LocalizationValue) -> LocalizedStringResource {
        .init(key, bundle: .module)
    }
    
    static var arrivalsBoardCountdownDue: LocalizedStringResource {
        moduleResource("arrivals.board.countdown.due")
    }
    
    static func arrivalsBoardCountdownDueMinutes(_ minutes: Int) -> LocalizedStringResource {
        moduleResource("arrivals.board.countdown.due.minutes \(minutes)")
    }
    
    static func arrivalsBoardCountdownDueSeconds(_ seconds: Int) -> LocalizedStringResource {
        moduleResource("arrivals.board.countdown.due.seconds \(seconds)")
    }
    
    static func arrivalsBoardDepartsAt(_ departureTime: String) -> LocalizedStringResource {
        moduleResource("arrivals.board.departs.at \(departureTime)")
    }
    
    static var arrivalsCheckFrontOfTrain: LocalizedStringResource {
        moduleResource("arrivals.check.front.of.train")
    }
    
    static var arrivalsNoData: LocalizedStringResource {
        moduleResource("arrivals.no.data")
    }
    
    static var arrivalsPickerAllStationsSectionTitle: LocalizedStringResource {
        moduleResource("arrivals.picker.all.stations.section.title")
    }
    
    static var arrivalsPickerFavouritesSectionTitle: LocalizedStringResource {
        moduleResource("arrivals.picker.favourites.section.title")
    }
    
    static var arrivalsPickerNavigationTitle: LocalizedStringResource {
        moduleResource("arrivals.picker.navigation.title")
    }
        
    static var arrivalsPickerNoSelection: LocalizedStringResource {
        moduleResource("arrivals.picker.no.selection")
    }
    
    static var arrivalsPickerSearchNoResults: LocalizedStringResource {
        moduleResource("arrivals.picker.search.no.results")
    }
    
    static var arrivalsPickerSearchPlaceholder: LocalizedStringResource {
        moduleResource("arrivals.picker.search.placeholder")
    }
    
    static var arrivalsTabTitle: LocalizedStringResource {
        moduleResource("arrivals.tab.title")
    }
    
    static var disruptionsCellDefaultTitle: LocalizedStringResource {
        moduleResource("disruptions.cell.default.title")
    }
    
    static var errorNoInternetConnection: LocalizedStringResource {
        moduleResource("error.no.internet.connection")
    }
    
    static var errorSomethingWentWrong: LocalizedStringResource {
        moduleResource("error.something.went.wrong")
    }
    
    static var favouritesButtonTitleAdd: LocalizedStringResource {
        moduleResource("favourites.button.title.add")
    }
    
    static var favouritesButtonTitleRemove: LocalizedStringResource {
        moduleResource("favourites.button.title.remove")
    }
    
    static var mailNotSupported: LocalizedStringResource {
        moduleResource("mail.not.supported")
    }
    
    static var contactUsBodyAppVersion: LocalizedStringResource {
        moduleResource("contact.us.body.app.version")
    }
    
    static var contactUsBodyDeviceInfo: LocalizedStringResource {
        moduleResource("contact.us.body.device.info")
    }
    
    static var contactUsBodyDiagnosticInfo: LocalizedStringResource {
        moduleResource("contact.us.body.diagnostic.info")
    }
    
    static var contactUsBodyLocaleInfo: LocalizedStringResource {
        moduleResource("contact.us.body.locale.info")
    }
    
    static var contactUsBodyOsVersion: LocalizedStringResource {
        moduleResource("contact.us.body.os.version")
    }
    
    static func contactUsSubject(_ subject: String) -> LocalizedStringResource {
        moduleResource("contact.us.subject \(subject)")
    }
    
    static var journeyLocationPickerNearbyStationsSectionTitle: LocalizedStringResource {
        moduleResource("journey.location.picker.nearby.stations.section.title")
    }
    
    static var journeyLocationPickerSuggestionsSectionTitle: LocalizedStringResource {
        moduleResource("journey.location.picker.suggestions.section.title")
    }
    
    static func journeyLocationSearchResultsCount(_ count: Int) -> LocalizedStringResource {
        moduleResource("journey.location.search.results.count \(count)")
    }
    
    static var journeyModePickerInstructionTitle: LocalizedStringResource {
        moduleResource("journey.mode.picker.instruction.title")
    }
    
    static var journeyModePickerMinimumSelectionWarning: LocalizedStringResource {
        moduleResource("journey.mode.picker.minimum.selection.warning")
    }

    static var journeyModePickerSelectAllButtonTitle: LocalizedStringResource {
        moduleResource("journey.mode.picker.select.all.button.title")
    }
    
    static var journeyModePickerValueBus: LocalizedStringResource {
        moduleResource("journey.mode.picker.value.bus")
    }
    
    static var journeyModePickerValueCableCar: LocalizedStringResource {
        moduleResource("journey.mode.picker.value.cable.car")
    }
    
    static var journeyModePickerValueCycle: LocalizedStringResource {
        moduleResource("journey.mode.picker.value.cycle")
    }
    
    static var journeyModePickerValueDlr: LocalizedStringResource {
        moduleResource("journey.mode.picker.value.dlr")
    }
    
    static var journeyModePickerValueElizabeth: LocalizedStringResource {
        moduleResource("journey.mode.picker.value.elizabeth")
    }
    
    static var journeyModePickerValueInvalid: LocalizedStringResource {
        moduleResource("journey.mode.picker.value.invalid")
    }
    
    static var journeyModePickerValueNationalRail: LocalizedStringResource {
        moduleResource("journey.mode.picker.value.national.rail")
    }
    
    static var journeyModePickerValueOverground: LocalizedStringResource {
        moduleResource("journey.mode.picker.value.overground")
    }
    
    static var journeyModePickerValueRiverBus: LocalizedStringResource {
        moduleResource("journey.mode.picker.value.river.bus")
    }
    
    static var journeyModePickerValueTram: LocalizedStringResource {
        moduleResource("journey.mode.picker.value.tram")
    }
    
    static var journeyModePickerValueTube: LocalizedStringResource {
        moduleResource("journey.mode.picker.value.tube")
    }
    
    static var journeyModePickerValueWalk: LocalizedStringResource {
        moduleResource("journey.mode.picker.value.walk")
    }
        
    static var journeyResultsToLabelTitle: LocalizedStringResource {
        moduleResource("journey.results.to.label.title")
    }
    
    static var journeyResultsZeroResultsTitle: LocalizedStringResource {
        moduleResource("journey.results.zero.results.title")
    }
    
    static func journeyResultsTimeOptionLeavingAt(_ departureTime: String) -> LocalizedStringResource {
        moduleResource("journey.results.time.option.leaving.at \(departureTime)")
    }
    
    static func journeyResultsTimeOptionArrivingBy(_ arrivalTime: String) -> LocalizedStringResource {
        moduleResource("journey.results.time.option.arriving.by \(arrivalTime)")
    }
    
    static var journeyResultsViaTitle: LocalizedStringResource {
        moduleResource("journey.results.via.title")
    }
    
    static var journeyPlannerFormErrorFieldRequired: LocalizedStringResource {
        moduleResource("journey.planner.form.error.field.required")
    }
    
    static var journeyPlannerFormErrorToFieldInvalid: LocalizedStringResource {
        moduleResource("journey.planner.form.error.to.field.invalid")
    }
    
    static var journeyPlannerFromPlaceholderTitle: LocalizedStringResource {
        moduleResource("journey.planner.from.placeholder.title")
    }
    
    static var journeyPlannerLocationButtonSelectLocation: LocalizedStringResource {
        moduleResource("journey.planner.location.button.select.location")
    }
    
    static var journeyPlannerLocationPickerPlaceholderText: LocalizedStringResource {
        moduleResource("journey.planner.location.picker.placeholder.text")
    }
    
    static var journeyPlannerLocationPickerScreenFromNavigationTitle: LocalizedStringResource {
        moduleResource("journey.planner.location.picker.screen.from.navigation.title")
    }
    
    static var journeyPlannerLocationPickerScreenToNavigationTitle: LocalizedStringResource {
        moduleResource("journey.planner.location.picker.screen.to.navigation.title")
    }
    
    static var journeyPlannerLocationPickerScreenViaNavigationTitle: LocalizedStringResource {
        moduleResource("journey.planner.location.picker.screen.via.navigation.title")
    }
    
    static var journeyPlannerLocationValueCurrentLocation: LocalizedStringResource {
        moduleResource("journey.planner.location.value.current.location")
    }
    
    static var journeyPlannerNavigationTitle: LocalizedStringResource {
        moduleResource("journey.planner.navigation.title")
    }
    
    static var journeyPlannerRecentJourneysSectionTitle: LocalizedStringResource {
        moduleResource("journey.planner.recent.journeys.section.title")
    }
    
    static func journeyPlannerResultsCount(_ count: Int) -> LocalizedStringResource {
        moduleResource("journey.planner.results.count \(count)")
    }
    
    static var journeyPlannerShowJourneysButtonTitle: LocalizedStringResource {
        moduleResource("journey.planner.show.journeys.button.title")
    }
    
    static func journeyPlannerStopsCount(_ count: Int) -> LocalizedStringResource {
        moduleResource("journey.planner.stops.count \(count)")
    }
    
    static var journeyPlannerTabTitle: LocalizedStringResource {
        moduleResource("journey.planner.tab.title")
    }
    
    static var journeyPlannerTimePickerOptionArriveBy: LocalizedStringResource {
        moduleResource("journey.planner.time.picker.option.arrive.by")
    }
    
    static var journeyPlannerTimePickerOptionLeaveLater: LocalizedStringResource {
        moduleResource("journey.planner.time.picker.option.leave.later")
    }
    
    static var journeyPlannerTimePickerOptionLeaveNow: LocalizedStringResource {
        moduleResource("journey.planner.time.picker.option.leave.now")
    }
    
    static var journeyPlannerToLabelTitle: LocalizedStringResource {
        moduleResource("journey.planner.to.label.title")
    }
    
    static var journeyPlannerToPlaceholderTitle: LocalizedStringResource {
        moduleResource("journey.planner.to.placeholder.title")
    }
    
    static var journeyPlannerTravelOptionsMainLabelTitle: LocalizedStringResource {
        moduleResource("journey.planner.travel.options.main.label.title")
    }
    
    static func journeyPlannerTravelOptionsDetailArriveBy(_ arrivalTime: String) -> LocalizedStringResource {
        moduleResource("journey.planner.travel.options.detail.arrive.by \(arrivalTime)")
    }
    
    static func journeyPlannerTravelOptionsDetailLeaveAt(_ departureTime: String) -> LocalizedStringResource {
        moduleResource("journey.planner.travel.options.detail.leave.at \(departureTime)")
    }
    
    static var journeyPlannerTravelOptionsModesDetailAll: LocalizedStringResource {
        moduleResource("journey.planner.travel.options.modes.detail.all")
    }
    
    static func journeyPlannerTravelOptionsModesSelectionCount(_ count: Int) -> LocalizedStringResource {
        moduleResource("journey.planner.travel.options.modes.selection.count \(count)")
    }
    
    
    static func journeyPlannerTravelOptionsVia(_ viaLocation: String) -> LocalizedStringResource {
        moduleResource("journey.planner.travel.options.via \(viaLocation)")
    }
    
    static var journeyPlannerTravelOptionsViaPlaceholderTitle: LocalizedStringResource {
        moduleResource("journey.planner.travel.options.via.placeholder.title")
    }
    
    static var journeyPlannerTravelOptionsWhenLabelTitle: LocalizedStringResource {
        moduleResource("journey.planner.travel.options.when.label.title")
    }
    
    static var journeyPlannerViaLabelTitle: LocalizedStringResource {
        moduleResource("journey.planner.via.label.title")
    }
    
    static var journeyResultsNavigationTitle: LocalizedStringResource {
        moduleResource("journey.results.navigation.title")
    }
    
    static var recentJourneyCellTo: LocalizedStringResource {
        moduleResource("recent.journey.cell.to")
    }
    
    static func recentJourneyCellVia(_ viaLocation: String) -> LocalizedStringResource {
        moduleResource("recent.journey.cell.via \(viaLocation)")
    }
    
    static func refreshStatusLastUpdated(_ date: String) -> LocalizedStringResource {
        moduleResource("refresh.status.last.updated \(date)")
    }
    
    static var refreshStatusLoading: LocalizedStringResource {
        moduleResource("refresh.status.loading")
    }
    
    static var searchSuggestionsSectionTitle: LocalizedStringResource {
        moduleResource("search.suggestions.section.title")
    }
    
    static var settingsAcknowledgementsTitle: LocalizedStringResource {
        moduleResource("settings.acknowledgements.title")
    }
    
    static var settingsAppPoweredBy: LocalizedStringResource {
        moduleResource("settings.app.powered.by")
    }
    
    static var settingsAppVersionTitle: LocalizedStringResource {
        moduleResource("settings.app.version.title")
    }
    
    static var settingsContactUsTitle: LocalizedStringResource {
        moduleResource("settings.contact.us.title")
    }
    
    static var settingsJourneyPlannerTitle: LocalizedStringResource {
        moduleResource("settings.journey.planner.title")
    }
    
    static var settingsJourneyPlannerTransportModes: LocalizedStringResource {
        moduleResource("settings.journey.planner.transport.modes")
    }
    
    static var settingsJourneyModePickerNavigationTitle: LocalizedStringResource {
        moduleResource("settings.journey.mode.picker.navigation.title")
    }
    
    static var settingsNavigationTitle: LocalizedStringResource {
        moduleResource("settings.navigation.title")
    }
    
    static var settingsRateThisAppTitle: LocalizedStringResource {
        moduleResource("settings.rate.this.app.title")
    }
    
    static var settingsSectionAboutTitle: LocalizedStringResource {
        moduleResource("settings.section.about.title")
    }
    
    static var settingsSectionSupportTitle: LocalizedStringResource {
        moduleResource("settings.section.support.title")
    }
    
    static var swapButtonAccessibilityTitle: LocalizedStringResource {
        moduleResource("swap.button.accessibility.title")
    }
    
    static var lineStatusDatePickerTitle: LocalizedStringResource {
        moduleResource("line.status.date.picker.title")
    }
    
    static func lineStatusDetailGoodServiceOnThe(_ lineName: String) -> LocalizedStringResource {
        moduleResource("line.status.detail.good.service.on.the \(lineName)")
    }
    
    static var lineStatusDetailGoodServiceOnTrams: LocalizedStringResource {
        moduleResource("line.status.detail.good.service.on.trams")
    }
    
    static var lineStatusFavouritesButtonFooter: LocalizedStringResource {
        moduleResource("line.status.favourites.button.footer")
    }
    
    static var lineStatusFilterOptionOther: LocalizedStringResource {
        moduleResource("line.status.filter.option.other")
    }
    
    static var lineStatusFilterOptionThisWeekend: LocalizedStringResource {
        moduleResource("line.status.filter.option.this.weekend")
    }
    
    static var lineStatusFilterOptionToday: LocalizedStringResource {
        moduleResource("line.status.filter.option.today")
    }
    
    static var lineStatusFilterOptionTomorrow: LocalizedStringResource {
        moduleResource("line.status.filter.option.tomorrow")
    }
    
    static var lineStatusNavigationTitle: LocalizedStringResource {
        moduleResource("line.status.navigation.title")
    }
    
    static var lineStatusNoSelection: LocalizedStringResource {
        moduleResource("line.status.no.selection")
    }
    
    static var lineStatusPlannedGoodServiceAllLinesTitle: LocalizedStringResource {
        moduleResource("line.status.planned.good.service.all.lines.title")
    }
    
    static var lineStatusPlannedGoodServiceOtherLinesTitle: LocalizedStringResource {
        moduleResource("line.status.planned.good.service.other.lines.title")
    }
    
    static func lineStatusPlannedStatusTitle(_ date: String) -> LocalizedStringResource {
        moduleResource("line.status.planned.status.title \(date)")
    }
    
    static var lineStatusSelectOtherDateTitle: LocalizedStringResource {
        moduleResource("line.status.select.other.date.title")
    }
    
    static var lineStatusTabTitle: LocalizedStringResource {
        moduleResource("line.status.tab.title")
    }
    
    static var lineStatusTflTweetsTitleAllLines: LocalizedStringResource {
        moduleResource("line.status.tfl.tweets.title.allLines")
    }
    
    static func lineStatusTflTweetsTitleLine(_ lineName: String) -> LocalizedStringResource {
        moduleResource("line.status.tfl.tweets.title.line \(lineName)")
    }
    
    static var lineStatusServiceNow: LocalizedStringResource {
        moduleResource("line.status.service.now")
    }
    
    static var lineStatusTwitterSectionTitle: LocalizedStringResource {
        moduleResource("line.status.twitterSection.title")
    }
    
    static var locationServicesAccessDeniedMessageTitle: LocalizedStringResource {
        moduleResource("location.services.access.denied.message.title")
    }
    
    static var locationServicesAllowAccessButtonTitle: LocalizedStringResource {
        moduleResource("location.services.allow.access.button.title")
    }
    
    static var locationServicesAllowAccessHeaderTitle: LocalizedStringResource {
        moduleResource("location.services.allow.access.header.title")
    }
    
    static var locationServicesAllowAccessFooterTitle: LocalizedStringResource {
        moduleResource("location.services.allow.access.footer.title")
    }
    
    static var mapsElizabethLinkTitle: LocalizedStringResource {
        moduleResource("maps.elizabeth.link.title")
    }
    
    static var mapsNavigationTitle: LocalizedStringResource {
        moduleResource("maps.navigation.title")
    }
    
    static var mapsRailAndTubeLinkTitle: LocalizedStringResource {
        moduleResource("maps.rail.and.tube.link.title")
    }
    
    static var mapsTabTitle: LocalizedStringResource {
        moduleResource("maps.tab.title")
    }
    
    static var mapsTubeDayLinkTitle: LocalizedStringResource {
        moduleResource("maps.tube.day.link.title")
    }
    
    static var mapsTubeNightLinkTitle: LocalizedStringResource {
        moduleResource("maps.tube.night.link.title")
    }
    
    static var nearbyStationsLoadFailureTitle: LocalizedStringResource {
        moduleResource("nearby.stations.load.failure.title")
    }
    
    static var nearbyStationsMoreResultsButtonTitle: LocalizedStringResource {
        moduleResource("nearby.stations.more.results.button.title")
    }
    
    static var nearbyStationsNavigationTitle: LocalizedStringResource {
        moduleResource("nearby.stations.navigation.title")
    }
    
    static var nearbyStationsNoResults: LocalizedStringResource {
        moduleResource("nearby.stations.no.results")
    }
    
    static var nearbyStationsNoSelection: LocalizedStringResource {
        moduleResource("nearby.stations.no.selection")
    }
    
    static var nearbyStationsTabTitle: LocalizedStringResource {
        moduleResource("nearby.stations.tab.title")
    }
    
    static var openAppSettingsButtonTitle: LocalizedStringResource {
        moduleResource("open.app.settings.button.title")
    }
    
    static var refreshButtonTitle: LocalizedStringResource {
        moduleResource("refresh.button.title")
    }
    
    static var stationArrivalsSectionHeaderTitle: LocalizedStringResource {
        moduleResource("station.arrivals.section.header.title")
    }
    
    static var stationDisruptionsSectionHeaderTitle: LocalizedStringResource {
        moduleResource("station.disruptions.section.header.title")
    }
    
    static var stationLocationDirectionsButtonTitle: LocalizedStringResource {
        moduleResource("station.location.directions.button.title")
    }
    
    static var stationLocationSectionHeaderTitle: LocalizedStringResource {
        moduleResource("station.location.section.header.title")
    }
    
    static var stationLocationShowInMapsButtonTitle: LocalizedStringResource {
        moduleResource("station.location.show.in.maps.button.title")
    }
    
    static func stationsSearchResultsCount(_ count: Int) -> LocalizedStringResource {
        moduleResource("stations.search.results.count \(count)")
    }
    
    static var stationStatusSectionHeaderTitle: LocalizedStringResource {
        moduleResource("station.status.section.header.title")
    }
}

// swiftlint:enable identifier_name
