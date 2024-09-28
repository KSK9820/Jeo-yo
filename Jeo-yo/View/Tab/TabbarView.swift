//
//  TabbarView.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/28/24.
//

import SwiftUI

struct TabbarView: View {
    @State private var selected: Tab = .main
    
    var body: some View {
        ZStack {
            TabView(selection: $selected) {
                Group {
                    NavigationStack {
                        EmptyView()
                    }
                    .tag(Tab.calendar)
                    
                    NavigationStack {
                        EmptyView()
                    }
                    .tag(Tab.main)
                    
                    NavigationStack {
                        EmptyView()
                    }
                    .tag(Tab.register)
                }
                .toolbar(.hidden, for: .tabBar)
            }
            
            VStack {
                Spacer()
                tabBar
            }
        }
    }
    
    private var tabBar: some View {
        HStack {
            Spacer()
            calenderTab()
            Spacer()
            mainTab()
            Spacer()
            registerTab()
            Spacer()
        }
        .padding()
        .frame(height: 72)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 8, y: 2)
        }
        .padding(.horizontal)
    }
    
    private func calenderTab() -> some View {
        Button {
            selected = .calendar
        } label: {
            TabBarButtonView(selected: $selected, tab: Tab.calendar)
        }
        .foregroundStyle(selected == .calendar ? .accentColor : Color.primary)
    }
    
    private func mainTab() -> some View {
        Button {
            selected = .main
        } label: {
            TabBarButtonView(selected: $selected, tab: Tab.main)
        }
        .foregroundStyle(selected == .main ? Color.accentColor : Color.primary)
    }
    
    private func registerTab() -> some View {
        Button {
            selected = .register
        } label: {
            TabBarButtonView(selected: $selected, tab: Tab.register)
        }
        .foregroundStyle(selected == .register ? Color.accentColor : Color.primary)
    }
}

struct TabBarButtonView: View {
    @Binding var selected: Tab
    var tab: Tab
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: tab.image)
                .resizable()
                .scaledToFit()
                .frame(width: 22)
            if selected == tab {
                Text(tab.title)
                    .font(.system(size: 11))
            }
        }
    }
}

#Preview {
    TabbarView()
}
