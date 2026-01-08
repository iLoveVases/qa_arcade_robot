import base64
from robot.libraries.BuiltIn import BuiltIn


class AuthLib:
    ROBOT_LIBRARY_SCOPE = "SUITE"

    @staticmethod
    def _normalize(value) -> str:

        value = str(value)

        if value == "${EMPTY}":
            return ""
        if value == "${SPACE}":
            return " "
        if value == "None":
            return ""
        return value

    def register_basic_auth(self, username, password):
        """Injectrs Basic Authentication headers into browser."""

        sel_lib = BuiltIn().get_library_instance('SeleniumLibrary')
        driver = sel_lib.driver

        user = self._normalize(username)
        pwd = self._normalize(password)

        auth_str = f"{user}:{pwd}"
        encoded_auth = base64.b64encode(auth_str.encode()).decode()

        # Chrome DevTools Protocol:
        driver.execute_cdp_cmd("Network.enable", {})
        driver.execute_cdp_cmd("Network.setExtraHTTPHeaders", {"headers": {"Authorization": f"Basic {encoded_auth}"}})