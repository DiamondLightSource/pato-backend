# ruff: noqa: E501
from string import Template

from pydantic import BaseModel, EmailStr, Field, model_validator

ALERT_FIELDS = ["particleCount", "astigmatism", "defocus", "resolution"]

EMAIL_HEADER = """
<html>
<body>
    <div class="wrapper" style="padding: 0.5%; text-align:center; border-radius: 5px; border: 1px solid #efefef">
	<div class="header" style="background: #001d55; text-align: center; padding-top: 15px; padding-bottom: 15px; border-top-left-radius: 5px; border-top-right-radius: 5px;">
        <img src="cid:logo-light.png" height="45"/>
	</div>
	<div>
"""

EMAIL_FOOTER = Template(
    """
    <p>To change your alert thresholds or disable alerts completely, <a href="$pato_link">update your alert preferences in PATo</a>.</p>
    <p style="border-top: 1px solid #001d55; background-color: #1040A1; padding: 10px; color: white;">© 2025, Diamond Light Source</p></div>
"""
)

ALERT_REGISTRATION_TEMPLATE = Template(
    """<h1>Successfully registered alerts for $session!</h1>
    <p>You will now receive alerts for <b>$session</b>, data collection group <b>#$dcg</b> if any values fall outside the following thresholds:</p>
    <table style="margin: 0 auto; text-align: center; padding: 30px;">
        <tr style="background-color: #1040A1; color: white;">
            <th width="200px">Value</th>
            <th width="100px">Min</th>
            <th width="100px">Max</th>
        </tr>
        $value_rows
    </table>
    """
)

REGISTRATION_VALUE_ROW = Template(
    """
<tr style="border-bottom: 1px solid black;">
    <td>$name</td>
    <td>$min</td>
    <td>$max</td>
</tr>"""
)


class EmailNotification(BaseModel):
    """Email notification request"""

    groupId: int
    message: str


class NotificationSignup(BaseModel):
    """Required information for signing up to notifications"""

    particleCountMin: int | None = Field(ge=0, default=None)
    particleCountMax: int | None = Field(ge=0, default=None)
    astigmatismMin: int | None = None
    astigmatismMax: int | None = None
    defocusMin: int | None = None
    defocusMax: int | None = None
    resolutionMin: int | None = Field(ge=0, default=None)
    resolutionMax: int | None = Field(ge=0, default=None)
    email: EmailStr

    @model_validator(mode="after")
    def check_max_greater_than_min(cls, data):
        for field in ALERT_FIELDS:
            max_value = getattr(data, field + "Max")
            min_value = getattr(data, field + "Min")
            assert (
                min_value is None or max_value is None or max_value > min_value
            ), f"{field}Max must be greater than {field}Min"

        return data
