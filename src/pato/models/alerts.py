# ruff: noqa: E501
from string import Template

from pydantic import BaseModel, EmailStr, Field, model_validator

ALERT_FIELDS = ["particleCount", "astigmatism", "defocus", "resolution"]

EMAIL_HEADER = """
<html>
<body>
    <div class="wrapper" style="padding: 0.5%; text-align:center; border-radius: 5px; border: 1px solid #efefef">
	<div class="header" style="background: #001d55; text-align: center; padding-top: 15px; padding-bottom: 15px; border-top-left-radius: 5px; border-top-right-radius: 5px;">
        <svg width="120" height="120" version="1.1" xmlns="http://www.w3.org/2000/svg">
            <g transform="matrix(.37271 0 0 .37271 -3.343e-7 .0014878)" stroke-width="2.6831">
            <path d="m0 160.98c0-88.908 72.073-160.98 160.98-160.98 88.911 0 160.99 72.073 160.99 160.98 0 88.907-72.075 160.98-160.99 160.98-88.908 0-160.98-72.073-160.98-160.98" fill="#fff"/>
            <path d="m222.71 254.64c-8.56 1.2229-11.317 7.8871-6.1307 14.802l23.701 31.598c23.669-13.431 43.611-32.657 57.855-55.791l-75.425 9.3905" fill="#facf07"/>
            <path d="m99.553 220.97c8.5615-1.2224 11.319-7.8813 6.1319-14.797l-61.997-82.665c-5.1911-6.916-3.7729-8.3307 3.1437-3.144l82.652 61.988c6.9161 5.192 13.575 2.4293 14.797-6.1267l14.613-150.7c1.2187-8.5613 3.2227-8.5613 4.4467 0l14.612 150.72c1.224 8.5573 7.8827 11.315 14.799 6.128l82.684-62.011c6.916-5.1867 8.3293-3.772 3.1427 3.144l-62.001 82.669c-5.1867 6.9161-2.4293 13.575 6.132 14.799l83.085 10.343c10.348-21.254 16.16-45.119 16.16-70.35 0-88.897-72.069-160.97-160.97-160.97-88.902 0-160.97 72.069-160.97 160.97 0 25.244 5.8208 49.123 16.173 70.381l83.369-10.38" fill="#facf07"/>
            <path d="m144.28 299.39c-1.2227-8.5563-7.8813-11.314-14.798-6.1307l-24.743 18.561c13.459 5.0198 27.784 8.2651 42.676 9.5104l-3.136-21.941" fill="#facf07"/>
            <path d="m177.95 299.37-3.1347 21.941c14.869-1.2682 29.163-4.5323 42.604-9.5682l-24.667-18.504c-6.9213-5.188-13.58-2.4255-14.803 6.1308" fill="#facf07"/>
            <path d="m99.553 254.65-75.744-9.4307c14.288 23.215 34.315 42.503 58.086 55.946l23.79-31.718c5.1875-6.9145 2.4296-13.573-6.1319-14.797" fill="#facf07"/>
            </g>
        </svg>
	</div>
	<div>
"""

EMAIL_FOOTER = """
    <p>To change your alert thresholds or disable alerts completely, <a href="$pato_link">update your alert preferences in PATo</a>.</p>
    <p style="border-top: 1px solid #001d55; background-color: #1040A1; padding: 10px; color: white;">© 2025, Diamond Light Source</p></div>
"""

ALERT_EMAIL_TEMPLATE = Template(EMAIL_HEADER + "$msg" + EMAIL_FOOTER)
ALERT_REGISTRATION_TEMPLATE = Template(
    EMAIL_HEADER
    + """<h1>Successfully registered alerts for $session!</h1>
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
    + EMAIL_FOOTER
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
