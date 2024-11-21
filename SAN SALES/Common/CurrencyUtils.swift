//
//  CurrencyUtils.swift
//  SAN SALES
//
//  Created by Anbu j on 19/11/24.
//

import Foundation

class CurrencyUtils {
        
    static  let countryToLocaleMap: [String: String] = [
            "AD": "ca_AD", "AE": "ar_AE", "AF": "fa_AF", "AG": "en_AG", "AI": "en_AI", "AL": "sq_AL", "AM": "hy_AM", "AO": "pt_AO",
            "AQ": "en_AQ", "AR": "es_AR", "AS": "en_AS", "AT": "de_AT", "AU": "en_AU", "AW": "nl_AW", "AX": "sv_AX", "AZ": "az_AZ",
            "BA": "bs_BA", "BB": "en_BB", "BD": "bn_BD", "BE": "nl_BE", "BF": "fr_BF", "BG": "bg_BG", "BH": "ar_BH", "BI": "rn_BI",
            "BJ": "fr_BJ", "BL": "fr_BL", "BM": "en_BM", "BN": "ms_BN", "BO": "es_BO", "BQ": "nl_BQ", "BR": "pt_BR", "BS": "en_BS",
            "BT": "dz_BT", "BV": "no_BV", "BW": "en_BW", "BY": "be_BY", "BZ": "es_BZ",
            "CA": "en_CA", "CC": "en_CC", "CD": "fr_CD", "CF": "fr_CF", "CG": "fr_CG", "CH": "de_CH", "CI": "fr_CI", "CK": "en_CK",
            "CL": "es_CL", "CM": "fr_CM", "CN": "zh_CN", "CO": "es_CO", "CR": "es_CR", "CU": "es_CU", "CV": "pt_CV", "CW": "nl_CW",
            "CX": "en_CX", "CY": "el_CY", "CZ": "cs_CZ",
            "DE": "de_DE", "DJ": "fr_DJ", "DK": "da_DK", "DM": "en_DM", "DO": "es_DO", "DZ": "ar_DZ",
            "EC": "es_EC", "EE": "et_EE", "EG": "ar_EG", "EH": "ar_EH", "ER": "ti_ER", "ES": "es_ES", "ET": "am_ET",
            "FI": "fi_FI", "FJ": "en_FJ", "FK": "es_FK", "FM": "en_FM", "FO": "fo_FO", "FR": "fr_FR",
            "GA": "fr_GA", "GB": "en_GB", "GD": "en_GD", "GE": "ka_GE", "GF": "fr_GF", "GG": "en_GG", "GH": "ak_GH", "GI": "en_GI",
            "GL": "kl_GL", "GM": "en_GM", "GN": "fr_GN", "GP": "fr_GP", "GQ": "es_GQ", "GR": "el_GR", "GT": "es_GT", "GU": "en_GU",
            "GW": "pt_GW", "GY": "en_GY",
            "HK": "zh_HK", "HM": "en_HM", "HN": "es_HN", "HR": "hr_HR", "HT": "ht_HT", "HU": "hu_HU",
            "ID": "id_ID", "IE": "en_IE", "IL": "he_IL", "IM": "en_IM", "IN": "en_IN", "IO": "en_IO", "IQ": "ar_IQ", "IR": "fa_IR",
            "IS": "is_IS", "IT": "it_IT",
            "JE": "en_JE", "JM": "en_JM", "JO": "ar_JO", "JP": "ja_JP",
            "KE": "en_KE", "KG": "ky_KG", "KH": "km_KH", "KI": "en_KI", "KM": "ar_KM", "KN": "en_KN", "KP": "ko_KP", "KR": "ko_KR",
            "KW": "ar_KW", "KY": "en_KY", "KZ": "kk_KZ",
            "LA": "lo_LA", "LB": "ar_LB", "LC": "en_LC", "LI": "de_LI", "LK": "si_LK", "LR": "en_LR", "LS": "en_LS", "LT": "lt_LT",
            "LU": "lb_LU", "LV": "lv_LV", "LY": "ar_LY",
            "MA": "ar_MA", "MC": "fr_MC", "MD": "ro_MD", "ME": "sr_ME", "MF": "fr_MF", "MG": "mg_MG", "MH": "en_MH", "MK": "mk_MK",
            "ML": "fr_ML", "MM": "my_MM", "MN": "mn_MN", "MO": "zh_MO", "MP": "en_MP", "MQ": "fr_MQ", "MR": "ar_MR", "MS": "en_MS",
            "MT": "mt_MT", "MU": "en_MU", "MV": "dv_MV", "MW": "ny_MW", "MX": "es_MX", "MY": "ms_MY", "MZ": "pt_MZ",
            "NA": "en_NA", "NC": "fr_NC", "NE": "fr_NE", "NF": "en_NF", "NG": "en_NG", "NI": "es_NI", "NL": "nl_NL", "NO": "no_NO",
            "NP": "ne_NP", "NR": "en_NR", "NU": "en_NU", "NZ": "en_NZ",
            "OM": "ar_OM",
            "PA": "es_PA", "PE": "es_PE", "PF": "fr_PF", "PG": "en_PG", "PH": "en_PH", "PK": "ur_PK", "PL": "pl_PL", "PM": "fr_PM",
            "PN": "en_PN", "PR": "es_PR", "PT": "pt_PT", "PW": "en_PW", "PY": "es_PY",
            "QA": "ar_QA",
            "RE": "fr_RE", "RO": "ro_RO", "RS": "sr_RS", "RU": "ru_RU", "RW": "rw_RW",
            "SA": "ar_SA", "SB": "en_SB", "SC": "en_SC", "SD": "ar_SD", "SE": "sv_SE", "SG": "en_SG", "SH": "en_SH", "SI": "sl_SI",
            "SJ": "no_SJ", "SK": "sk_SK", "SL": "en_SL", "SM": "it_SM", "SN": "fr_SN", "SO": "so_SO", "SR": "sr_SR", "SS": "en_SS",
            "ST": "pt_ST", "SV": "es_SV", "SX": "nl_SX", "SY": "ar_SY", "SZ": "ss_SZ",
            "TC": "en_TC", "TD": "fr_TD", "TF": "fr_TF", "TG": "fr_TG", "TH": "th_TH", "TJ": "tg_TJ", "TK": "en_TK", "TL": "pt_TL",
            "TM": "tk_TM", "TN": "ar_TN", "TO": "en_TO", "TR": "tr_TR", "TT": "en_TT", "TV": "en_TV", "TW": "zh_TW", "TZ": "sw_TZ",
            "UA": "uk_UA", "UG": "en_UG", "UM": "en_UM", "US": "en_US", "UY": "es_UY", "UZ": "uz_UZ",
            "VA": "it_VA", "VC": "en_VC", "VE": "es_VE", "VG": "en_VG", "VI": "en_VI", "VN": "vi_VN", "VU": "bi_VU",
            "WF": "fr_WF", "WS": "en_WS",
            "YE": "ar_YE", "YT": "fr_MQ",
            "ZA": "en_ZA", "ZM": "en_ZM", "ZW": "en_ZW"
        ]

    static func findLocaleIdentifier(forCurrencySymbol symbol: String) -> String? {
        for localeId in Locale.availableIdentifiers {
            let locale = Locale(identifier: localeId)
            if locale.currencySymbol == symbol {
                if let regionCode = locale.regionCode,
                   let mappedLocaleId = countryToLocaleMap[regionCode] {
                    print(mappedLocaleId)
                    
                    return mappedLocaleId
                }
                return Locale.current.identifier
            }
        }
        return nil
    }
    
    static func formatCurrency(amount: Any, currencySymbol: String) -> String {
        let amountAsDouble: Double
        if let doubleValue = amount as? Double {
            amountAsDouble = doubleValue
        } else if let intValue = amount as? Int {
            amountAsDouble = Double(intValue)
        }else if let intValue = amount as? Float {
            amountAsDouble = Double(intValue)
        }else if let stringValue = amount as? String, let doubleValue = Double(stringValue) {
            amountAsDouble = doubleValue
        } else {
            return "\(currencySymbol)0.00"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = currencySymbol
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.groupingSeparator = ","
        
        var identifier = Locale.current.identifier
        if let localeId = findLocaleIdentifier(forCurrencySymbol: currencySymbol) {
            print("Locale Identifier: \(localeId)")
            identifier = localeId
        }
        
        formatter.locale = Locale(identifier: identifier)
        return formatter.string(from: NSNumber(value: amountAsDouble)) ?? "\(currencySymbol) \(amountAsDouble)"
    }
}
