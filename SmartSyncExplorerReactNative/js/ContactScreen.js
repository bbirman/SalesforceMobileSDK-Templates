/*
 * Copyright (c) 2015-present, salesforce.com, inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided
 * that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the
 * following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and
 * the following disclaimer in the documentation and/or other materials provided with the distribution.
 *
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to endorse or
 * promote products derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

import React from 'react';
import {
    Platform,
    ScrollView,
    StyleSheet,
    View,
    TouchableHighlight,
    Text
} from 'react-native';

import Field from './Field';
import storeMgr from './StoreMgr';
import { Card, Button } from 'react-native-elements';

// State: contact
// Props: contact
var createReactClass = require('create-react-class');
const ContactScreen = createReactClass({
    getInitialState() {
        return {
            contact: this.props.contact
        };
    },

    onChange(fieldKey, fieldValue) {
        const contact = this.state.contact;
        contact[fieldKey] = fieldValue;
        this.setState({contact});
    },

    onDeleteUndeleteContact() {
        const contact = this.state.contact;
        const navigator = this.navigator;
        contact.__locally_deleted__ = !contact.__locally_deleted__;
        contact.__local__ = contact.__locally_deleted__ || contact.__locally_updated__ || contact.__locally_created__;
        storeMgr.saveContact(contact, () => {this.props.navigator.pop()});
    },

    renderErrorIfAny() {
        var errorMessage = null;
        const lastError = this.state.contact.__last_error__;
        if (lastError) {
            try {
                if (Platform.OS == 'ios') {
                    errorMessage = new RegExp('.*message = "([^"]*)".*', 'm').exec(lastError)[1];
                } else {
                    errorMessage = JSON.parse(lastError)[0].message;
                }
            }
            catch (e) {
                console.log("Failed to extract message from error: " + lastError);
            }
        }

        if (errorMessage == null) {
            return null;
        } else {

            return (
                    <View style={{marginTop:10}}>
                    <Button
                      icon={{name: 'error', size: 15, color: 'white'}}
                      title={errorMessage}
                      buttonStyle={{backgroundColor:'red'}}
                    />
                    </View>
            );
        }
    },

    renderDeleteUndeleteButton() {
        var iconName = 'delete';
        var title = 'Delete';
        var bgColor = 'red';
        if (this.state.contact.__locally_deleted__) {
            iconName = 'delete-restore';
            title = 'Undelete';
            bgColor = 'blue';
        } 

        return (
                <View style={{marginTop:10}}>
                <Button
                  backgroundColor={bgColor}
                  containerStyle={{alignItems:'stretch'}}
                  icon={{name: iconName, type: 'material-community'}}
                  title={title}
                  onPress={this.onDeleteUndeleteContact}
                />
                </View>
        );
    },

    render() {
        return (
                <ScrollView>
                  <View style={this.props.style}>
                    {this.renderErrorIfAny()}
                    <Field fieldLabel="First name" fieldValue={this.state.contact.FirstName} onChange={(text) => this.onChange("FirstName", text)}/>
                    <Field fieldLabel="Last name" fieldValue={this.state.contact.LastName} onChange={(text) => this.onChange("LastName", text)}/>
                    <Field fieldLabel="Title" fieldValue={this.state.contact.Title} onChange={(text) => this.onChange("Title", text)}/>
                    <Field fieldLabel="Mobile phone" fieldValue={this.state.contact.MobilePhone} onChange={(text) => this.onChange("MobilePhone", text)}/>
                    <Field fieldLabel="Email address" fieldValue={this.state.contact.Email} onChange={(text) => this.onChange("Email", text)}/>
                    <Field fieldLabel="Department" fieldValue={this.state.contact.Department} onChange={(text) => this.onChange("Department", text)}/>
                    <Field fieldLabel="Home phone" fieldValue={this.state.contact.HomePhone} onChange={(text) => this.onChange("HomePhone", text)}/>
                    {this.renderDeleteUndeleteButton()}
                  </View>
                </ScrollView>
               );
    }
});

export default ContactScreen;
