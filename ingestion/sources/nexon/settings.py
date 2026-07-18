# -------------------------------------------------------------------------------------
# API base URL for Nexon API
# -------------------------------------------------------------------------------------
BASE_URL = "https://open.api.nexon.com"

# -------------------------------------------------------------------------------------
# Variables (for transformer logic)
# -------------------------------------------------------------------------------------
MIN_TRACK_LEVEL = 260
REQUEST_DELAY = 0.3  # seconds

# -------------------------------------------------------------------------------------
# Endpoints (relative to BASE_URL)
# -------------------------------------------------------------------------------------
ENDPOINTS = {
    # User 계정 정보 조회
    "character_list": {
        "path": "/maplestory/v1/character/list",  # 캐릭터 목록 조회
    },
    "user_achievement": {
        "path": "/maplestory/v1/user/achievement",  # 업적 정보 조회
    },
    # Character 캐릭터 정보 조회
    # "id": {
    #     "path": "/maplestory/v1/id",  # 캐릭터 식별자(ocid) 조회
    # },
    "character_basic": {
        "path": "/maplestory/v1/character/basic",  # 기본 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "character_popularity": {
        "path": "/maplestory/v1/character/popularity",  # 인기도 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "character_stat": {
        "path": "/maplestory/v1/character/stat",  # 종합 능력치 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "character_hyper_stat": {
        "path": "/maplestory/v1/character/hyper-stat",  # 하이퍼스탯 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "character_propensity": {
        "path": "/maplestory/v1/character/propensity",  # 성향 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "character_ability": {
        "path": "/maplestory/v1/character/ability",  # 어빌리티 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "character_item_equipment": {
        "path": "/maplestory/v1/character/item-equipment",  # 장착 장비 정보 조회 (캐시 장비 제외)
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "character_cash_item_equipment": {
        "path": "/maplestory/v1/character/cashitem-equipment",  # 장착 캐시 장비 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "character_symbol_equipment": {
        "path": "/maplestory/v1/character/symbol-equipment",  # 장착 심볼 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "character_set_effect": {
        "path": "/maplestory/v1/character/set-effect",  # 적용 세트 효과 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "character_beauty_equipment": {
        "path": "/maplestory/v1/character/beauty-equipment",  # 장착 헤어, 성형, 피부 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "character_android_equipment": {
        "path": "/maplestory/v1/character/android-equipment",  # 장착 안드로이드 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "character_pet_equipment": {
        "path": "/maplestory/v1/character/pet-equipment",  # 장착 펫 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    # "character_skill": {
    #     "path": "/maplestory/v1/character/skill",  # 스킬 정보 조회
    #     "params": {
    #         "ocid": "required",  # 캐릭터 식별자
    #         "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
    #         "character_skill_grade": "required",  # 조회하고자 하는 전직 차수 (0, 1, 1.5, 2, 2.5, 3, 4, hyperpassive, hyperactive, 5, 6)
    #     },
    # },
    "character_link_skill": {
        "path": "/maplestory/v1/character/link-skill",  # 장착 링크 스킬 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "character_vmatrix": {
        "path": "/maplestory/v1/character/vmatrix",  # V매트릭스 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "character_hexamatrix": {
        "path": "/maplestory/v1/character/hexamatrix",  # HEXA 코어 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "character_hexamatrix_stat": {
        "path": "/maplestory/v1/character/hexamatrix-stat",  # HEXA 매트릭스 설정 HEXA 스탯 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "character_dojang": {
        "path": "/maplestory/v1/character/dojang",  # 무릉도장 최고 기록 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "character_other_stat": {
        "path": "/maplestory/v1/character/other-stat",  # 기타 능력치 영향 요소 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    # "character_ring_exchange_skill_equipment": {
    #     "path": "/maplestory/v1/character/ring-exchange-skill-equipment",  # 링 익스체인지 스킬 등록 장비 조회
    #     "params": {
    #         "ocid": "required",  # 캐릭터 식별자
    #         "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
    #     },
    # },
    "character_ring_reserve_skill_equipment": {
        "path": "/maplestory/v1/character/ring-reserve-skill-equipment",  # 예비 특수 반지 장착 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    # Union 유니온 정보 조회
    "user_union": {
        "path": "/maplestory/v1/user/union",  # 유니온 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "user_union_raider": {
        "path": "/maplestory/v1/user/union-raider",  # 유니온 공격대 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "user_union_artifact": {
        "path": "/maplestory/v1/user/union-artifact",  # 유니온 아티팩트 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    "user_union_champion": {
        "path": "/maplestory/v1/user/union-champion",  # 유니온 챔피언 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD)
        },
    },
    # Scheduler 스케줄러 정보 조회
    "scheduler_character_state": {
        "path": "/maplestory/v1/scheduler/character-state",  # 캐릭터의 스케줄러 정보 조회
        "params": {
            "ocid": "required",  # 캐릭터 식별자
            "date": "optional",  # 조회 기준일 (KST, YYYY-MM-DD) / 캐릭터가 해당 기준일에 접속하지 않은 경우, 응답 결과가 없을 수 있음
        },
    },
    # Notice 공지 정보 조회
    "notice": {
        "path": "/maplestory/v1/notice",  # 공지사항 목록 조회
    },
    "notice_detail": {
        "path": "/maplestory/v1/notice/detail",  # 공지사항 상세 조회
        "params": {
            "notice_id": "required",  # 공지 식별자
        },
    },
    "notice_update": {
        "path": "/maplestory/v1/notice-update",  # 업데이트 목록 조회
    },
    "notice_update_detail": {
        "path": "/maplestory/v1/notice-update/detail",  # 업데이트 상세 조회
        "params": {
            "notice_id": "required",  # 업데이트 식별자
        },
    },
    "notice_event": {
        "path": "/maplestory/v1/notice-event",  # 진행 중 이벤트 목록 조회
    },
    "notice_event_detail": {
        "path": "/maplestory/v1/notice-event/detail",  # 진행 중 이벤트 상세 조회
        "params": {
            "notice_id": "required",  # 진행 중 이벤트 식별자
        },
    },
    "notice_cashshop": {
        "path": "/maplestory/v1/notice-cashshop",  # 캐시샵 공지 목록 조회
    },
    "notice_cashshop_detail": {
        "path": "/maplestory/v1/notice-cashshop/detail",  # 캐시샵 공지 상세 조회
        "params": {
            "notice_id": "required",  # 캐시샵 공지 식별자
        },
    },
}
