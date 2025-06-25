//
//  SubscriptionView.swift
//  Shifty
//
//  Created by 이민호 on 6/24/25.
//

import SwiftUI
import Resolver

struct SubscriptionView: View {
    @StateObject var viewModel: SubscriptionViewModel
    var width: CGFloat
    var height: CGFloat
    
    init(viewModel: SubscriptionViewModel, width: CGFloat, height: CGFloat) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.width = width
        self.height = height
    }    
    
    var body: some View {
        VStack(spacing: 50) {
            headerSection
            
            pricingSection
            
            actionButtons
        }
        .frame(width: width, height: height)
        .padding()
        .background(
            VisualEffectView.panelWithOverlay
        )
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Shifty Pro")
                .font(.title)
                .fontWeight(.bold)
            
            Text(String(localized: "folderLimit"))
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(String(localized: "folderLimitExplain"))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var pricingSection: some View {
        VStack(spacing: 8) {
            Text(StoreKitConfig.getPrice())
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 4) {
                Text(String(localized: "sevenDaysFree"))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.accentColor)
                
                Text(String(localized: "cancelAnytime"))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.accentColor.opacity(0.1))
        )
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: {
                Task {
                    
                }
            }) {
                HStack {
                    Text(String(localized: "sevenDaysTrial"))
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(
                    LinearGradient(
                        colors: [.accentColor, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(String(localized: "later")) {
                viewModel.escape()
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            .buttonStyle(PlainButtonStyle())
        }
    }
}


#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    
    SubscriptionView(
        viewModel: viewModelContainer.subscriptionViewModel,
        width: 400,
        height: 500
    )    
}
