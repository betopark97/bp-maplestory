# -------------------------------------------------------------------------------------
# API base URL for Nexon API
# -------------------------------------------------------------------------------------
BASE_URL = "https://open.api.nexon.com"

# -------------------------------------------------------------------------------------
# Endpoints (relative to BASE_URL)
# -------------------------------------------------------------------------------------
# User 계정 정보 조회
CHARACTER_LIST = "/maplestory/v1/character/list" # 캐릭터 목록 조회
USER_ACHIEVEMENT = "/maplestory/v1/character/achievement" # 업적 정보 조회

# Character 캐릭터 정보 조회
ID = "/maplestory/v1/id" # 캐릭터 식별자(ocid) 조회
CHARACTER_BASIC = "/maplestory/v1/character/basic" # 기본 정보 조회
CHARACTER_POPULARITY = "/maplestory/v1/character/popularity" # 인기도 정보 조회
CHARACTER_STAT = "/maplestory/v1/character/stat" # 종합 능력치 정보 조회
CHARACTER_HYPER_STAT = "/maplestory/v1/character/hyper-stat" # 하이퍼스탯 정보 조회
CHARACTER_PROPENSITY = "/maplestory/v1/character/propensity" # 성향 정보 조회
CHARACTER_ABILITY = "/maplestory/v1/character/ability" # 어빌리티 정보 조회
CHARACTER_ITEM_EQUIPMENT = "/maplestory/v1/character/item-equipment" # 장착 장비 정보 조회 (캐시 장비 제외)
CHARACTER_CASH_ITEM_EQUIPMENT = "/maplestory/v1/character/cashitem-equipment" # 장착 캐시 장비 정보 조회
CHARACTER_SYMBOL_EQUIPMENT = "/maplestory/v1/character/symbol-equipment" # 장착 심볼 정보 조회
CHARACTER_SET_EFFECT = "/maplestory/v1/character/set-effect" # 적용 세트 효과 정보 조회
CHARACTER_BEAUTY_EQUIPMENT = "/maplestory/v1/character/beauty-equipment" # 장착 헤어, 성형, 피부 정보 조회
CHARACTER_ANDROID_EQUIPMENT = "/maplestory/v1/character/android-equipment" # 장착 안드로이드 정보 조회
CHARACTER_PET_EQUIPMENT = "/maplestory/v1/character/pet-equipment" # 장착 펫 정보 조회
CHARACTER_SKILL = "/maplestory/v1/character/skill" # 스킬 정보 조회
CHARACTER_LINK_SKILL = "/maplestory/v1/character/link-skill" # 장착 링크 스킬 정보 조회
CHARACTER_VMATRIX = "/maplestory/v1/character/vmatrix" # V매트릭스 정보 조회
CHARACTER_HEXAMATRIX = "/maplestory/v1/character/hexamatrix" # HEXA 코어 정보 조회
CHARACTER_HEXAMATRIX_STAT = "/maplestory/v1/character/hexamatrix-stat" # HEXA 매트릭스 설정 HEXA 스탯 정보 조회
CHARACTER_DOJANG = "/maplestory/v1/character/dojang" # 무릉도장 최고 기록 정보 조회
CHARACTER_OTHER_STAT = "/maplestory/v1/character/other-stat" # 기타 능력치 영향 요소 정보 조회
CHARACTER_RING_EXCHANGE_SKILL_EQUIPMENT = "/maplestory/v1/character/ring-exchange-skill-equipment" # 링 익스체인지 스킬 등록 장비 조회
CHARACTER_RING_RESERVE_SKILL_EQUIPMENT = "/maplestory/v1/character/ring-reserve-skill-equipment" # 예비 특수 반지 장착 정보 조회