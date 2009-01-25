#--                                                  /THIS FILE IS A PART OF RUBYCAMPUS/
# +------------------------------------------------------------------------------------+
# | RubyCampus - Student & Alumni Relationship Management Software                     |
# +------------------------------------------------------------------------------------+
# | Copyright © 2008-2009 Kevin R. Aleman. Fukuoka, Japan. All Rights Reserved.        |
# +------------------------------------------------------------------------------------+
# |                                                                                    |
# | This program is free software; you can redistribute it and/or modify it under the  |
# | terms of the GNU Affero General Public License version 3 as published by the Free  |
# | Software Foundation with the addition of the following permission added to Section |
# | 15 as permitted in Section 7(a): FOR ANY PART OF THE COVERED WORK IN WHICH THE     |
# | COPYRIGHT IS OWNED BY KEVIN R ALEMAN, KEVIN R ALEMAN DISCLAIMS THE WARRANTY OF NON |
# | INFRINGEMENT OF THIRD PARTY RIGHTS.                                                |
# |                                                                                    |
# | This program is distributed in the hope that it will be useful, but WITHOUT ANY    |
# | WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A    |
# | PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.   |
# |                                                                                    |
# | You should have received a copy of the GNU Affero General Public License along     |
# | with this program; if not, see http://www.gnu.org/licenses or write to the Free    |
# | Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  |
# | USA.                                                                               |
# |                                                                                    |
# | You can contact the author Kevin R. Aleman by email at KALEMAN@RUBYCAMPUS.ORG. The |
# |                                                                                    |
# | The interactive user interfaces in modified source and object code versions of     |
# | this program must display Appropriate Legal Notices, as required under Section 5   |
# | of the GNU Affero General Public License version 3.                                |
# |                                                                                    |
# | In accordance with Section 7(b) of the GNU Affero General Public License version   |
# | 3, these Appropriate Legal Notices must retain the display of the "Powered by      |
# | RubyCampus" logo. If the display of the logo is not reasonably feasible for        |
# | technical reasons, the Appropriate Legal Notices must display the words "Powered   |
# | by RubyCampus".                                                                    |
# +------------------------------------------------------------------------------------+
#++

# A Site key gives additional protection against a dictionary attack if your
# DB is ever compromised.  With no site key, we store
#   DB_password = hash(user_password, DB_user_salt)
# If your database were to be compromised you'd be vulnerable to a dictionary
# attack on all your stupid users' passwords.  With a site key, we store
#   DB_password = hash(user_password, DB_user_salt, Code_site_key)
#
# Please note: if you change this, all the passwords will be invalidated, so DO
# keep it someplace secure.  Use the a random value that is moderately long and 
# unpredictable text.
                              # YOU MUST CHANGE THIS BEFORE GOING INTO PRODUCTION
REST_AUTH_SITE_KEY         = 'y0umu3tchang3th1sf0ry0urrubycampuss1t3'
  
# Repeated applications of the hash make brute force (even with a compromised
# database and site key) harder, and scale with Moore's law.
#
#   bq. "To squeeze the most security out of a limited-entropy password or
#   passphrase, we can use two techniques [salting and stretching]... that are
#   so simple and obvious that they should be used in every password system.
#   There is really no excuse not to use them." http://tinyurl.com/37lb73
#   Practical Security (Ferguson & Scheier) p350
# 
# A modest 10 foldings (the default here) adds 3ms.  This makes brute forcing 10
# times harder, while reducing an app that otherwise serves 100 reqs/s to 78 signin
# reqs/s, an app that does 10reqs/s to 9.7 reqs/s
# 
# More:
# * http://www.owasp.org/index.php/Hashing_Java
# * "An Illustrated Guide to Cryptographic Hashes":http://www.unixwiz.net/techtips/iguide-crypto-hashes.html

REST_AUTH_DIGEST_STRETCHES = 10
