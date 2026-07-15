# -------------------------------------------------------------------------------------
# API base URL for Nexon API
# -------------------------------------------------------------------------------------
BASE_URL = "https://open.api.nexon.com"

# -------------------------------------------------------------------------------------
# Endpoints (relative to BASE_URL)
# -------------------------------------------------------------------------------------
ENDPOINTS = {
    # User 계정 정보 조회
    "character_list": "/maplestory/v1/character/list",  # 캐릭터 목록 조회
    "user_achievement": "/maplestory/v1/user/achievement",  # 업적 정보 조회
    # Character 캐릭터 정보 조회
    "id": "/maplestory/v1/id",  # 캐릭터 식별자(ocid) 조회
    "character_basic": "/maplestory/v1/character/basic",  # 기본 정보 조회
    "character_popularity": "/maplestory/v1/character/popularity",  # 인기도 정보 조회
    "character_stat": "/maplestory/v1/character/stat",  # 종합 능력치 정보 조회
    "character_hyper_stat": "/maplestory/v1/character/hyper-stat",  # 하이퍼스탯 정보 조회
    "character_propensity": "/maplestory/v1/character/propensity",  # 성향 정보 조회
    "character_ability": "/maplestory/v1/character/ability",  # 어빌리티 정보 조회
    "character_item_equipment": "/maplestory/v1/character/item-equipment",  # 장착 장비 정보 조회 (캐시 장비 제외)
    "character_cash_item_equipment": "/maplestory/v1/character/cashitem-equipment",  # 장착 캐시 장비 정보 조회
    "character_symbol_equipment": "/maplestory/v1/character/symbol-equipment",  # 장착 심볼 정보 조회
    "character_set_effect": "/maplestory/v1/character/set-effect",  # 적용 세트 효과 정보 조회
    "character_beauty_equipment": "/maplestory/v1/character/beauty-equipment",  # 장착 헤어, 성형, 피부 정보 조회
    "character_android_equipment": "/maplestory/v1/character/android-equipment",  # 장착 안드로이드 정보 조회
    "character_pet_equipment": "/maplestory/v1/character/pet-equipment",  # 장착 펫 정보 조회
    "character_skill": "/maplestory/v1/character/skill",  # 스킬 정보 조회
    "character_link_skill": "/maplestory/v1/character/link-skill",  # 장착 링크 스킬 정보 조회
    "character_vmatrix": "/maplestory/v1/character/vmatrix",  # V매트릭스 정보 조회
    "character_hexamatrix": "/maplestory/v1/character/hexamatrix",  # HEXA 코어 정보 조회
    "character_hexamatrix_stat": "/maplestory/v1/character/hexamatrix-stat",  # HEXA 매트릭스 설정 HEXA 스탯 정보 조회
    "character_dojang": "/maplestory/v1/character/dojang",  # 무릉도장 최고 기록 정보 조회
    "character_other_stat": "/maplestory/v1/character/other-stat",  # 기타 능력치 영향 요소 정보 조회
    "character_ring_exchange_skill_equipment": "/maplestory/v1/character/ring-exchange-skill-equipment",  # 링 익스체인지 스킬 등록 장비 조회
    "character_ring_reserve_skill_equipment": "/maplestory/v1/character/ring-reserve-skill-equipment",  # 예비 특수 반지 장착 정보 조회
}
